package services

import (
	"fmt"

	"fatcat-backend/internal/config"
	"fatcat-backend/internal/models"
)

func CreateUniqueInviteCode() (string, error) {
	for {
		code := GenerateRandomString(8)
		var existing models.Class
		if err := config.DB.Where("code_invite = ?", code).First(&existing).Error; err != nil {
			return code, nil
		}
	}
}

func CreateClass(name, description string, userID uint) (*models.Class, error) {
	if name == "" || description == "" || userID == 0 {
		return nil, fmt.Errorf("name, description or userId is required")
	}

	inviteCode, err := CreateUniqueInviteCode()
	if err != nil {
		return nil, fmt.Errorf("create invite code failed")
	}

	newClass := models.Class{
		Name:        name,
		Description: description,
		CodeInvite:  inviteCode,
		HostUserID:  userID,
		MemberCount: 1,
	}
	if err := config.DB.Create(&newClass).Error; err != nil {
		return nil, fmt.Errorf("create class failed")
	}

	member := models.ClassMember{
		UserID:  userID,
		ClassID: newClass.ID,
		Role:    "host",
	}
	config.DB.Create(&member)

	return &newClass, nil
}

func GetClassesForHost(userID uint) ([]models.Class, error) {
	var classes []models.Class
	config.DB.Where("host_user_id = ?", userID).Find(&classes)
	return classes, nil
}

func JoinClass(userID uint, codeInvite string) (map[string]interface{}, error) {
	var foundClass models.Class
	if err := config.DB.Where("code_invite = ?", codeInvite).First(&foundClass).Error; err != nil {
		return nil, fmt.Errorf("class not found")
	}

	var existing models.ClassMember
	if err := config.DB.Where("user_id = ? AND class_id = ?", userID, foundClass.ID).First(&existing).Error; err == nil {
		return nil, fmt.Errorf("you have already joined this class")
	}

	member := models.ClassMember{
		UserID:  userID,
		ClassID: foundClass.ID,
	}
	config.DB.Create(&member)
	config.DB.Model(&foundClass).Update("member_count", foundClass.MemberCount+1)

	return map[string]interface{}{
		"member": map[string]interface{}{
			"id":       member.ID,
			"user_id":  member.UserID,
			"class_id": member.ClassID,
			"role":     member.Role,
		},
	}, nil
}

type MemberInfo struct {
	MemberID  uint   `json:"memberId"`
	UserID    uint   `json:"userId"`
	UserName  string `json:"userName"`
	UserEmail string `json:"userEmail"`
	ClassID   uint   `json:"classId"`
	Role      string `json:"role"`
	JoinedAt  interface{} `json:"joinedAt"`
}

func GetMembers(classID uint) (map[string]interface{}, error) {
	var members []models.ClassMember
	config.DB.Where("class_id = ?", classID).Preload("User").Order("joined_at ASC").Find(&members)

	flat := make([]MemberInfo, len(members))
	for i, m := range members {
		info := MemberInfo{
			MemberID:  m.ID,
			ClassID:   m.ClassID,
			Role:      m.Role,
			JoinedAt:  m.JoinedAt,
		}
		if m.User != nil {
			info.UserID = m.User.ID
			info.UserName = m.User.Name
			info.UserEmail = m.User.Email
		}
		flat[i] = info
	}

	return map[string]interface{}{
		"memberCount": len(flat),
		"members":     flat,
	}, nil
}

func GetAllClasses() ([]models.Class, error) {
	var classes []models.Class
	config.DB.Find(&classes)
	return classes, nil
}

type ClassInfo struct {
	ID          uint        `json:"id"`
	Name        string      `json:"name"`
	Description string      `json:"description"`
	HostUserID  uint        `json:"host_user_id"`
	MemberCount int         `json:"member_count"`
	CodeInvite  string      `json:"code_invite"`
	Role        string      `json:"role"`
	JoinedAt    interface{} `json:"joined_at"`
	CreatedAt   interface{} `json:"created_at"`
	UpdatedAt   interface{} `json:"updated_at"`
}

func GetClassesByUserID(userID uint, sortBy string) ([]ClassInfo, error) {
	var members []models.ClassMember
	query := config.DB.Where("user_id = ?", userID).Preload("Class")

	if sortBy == "member_count" {
		query = query.Joins("JOIN Classes ON class_members.class_id = Classes.id").Order("Classes.member_count DESC")
	} else if sortBy == "created_at" {
		query = query.Joins("JOIN Classes ON class_members.class_id = Classes.id").Order("Classes.created_at DESC")
	} else if sortBy == "updated_at" {
		query = query.Joins("JOIN Classes ON class_members.class_id = Classes.id").Order("Classes.updated_at DESC")
	}

	query.Find(&members)

	data := make([]ClassInfo, 0, len(members))
	for _, m := range members {
		if m.Class == nil {
			continue
		}
		data = append(data, ClassInfo{
			ID:          m.Class.ID,
			Name:        m.Class.Name,
			Description: m.Class.Description,
			HostUserID:  m.Class.HostUserID,
			MemberCount: m.Class.MemberCount,
			CodeInvite:  m.Class.CodeInvite,
			Role:        m.Role,
			JoinedAt:    m.JoinedAt,
			CreatedAt:   m.Class.CreatedAt,
			UpdatedAt:   m.Class.UpdatedAt,
		})
	}
	return data, nil
}

func UpdateClass(classID uint, name, description string) error {
	if name == "" || description == "" {
		return fmt.Errorf("name or description is required")
	}
	return config.DB.Model(&models.Class{}).Where("id = ?", classID).Updates(map[string]interface{}{
		"name":        name,
		"description": description,
	}).Error
}

func DeleteClass(classID uint, userID uint) error {
	result := config.DB.Where("id = ? AND host_user_id = ?", classID, userID).Delete(&models.Class{})
	if result.RowsAffected == 0 {
		return fmt.Errorf("delete class failed. you are not the host of this class")
	}
	return result.Error
}

func DeleteMember(userID uint, classID uint, hostUserID uint) error {
	var classInfo models.Class
	if err := config.DB.Where("id = ? AND host_user_id = ?", classID, userID).First(&classInfo).Error; err == nil {
		return fmt.Errorf("member cannot delete member")
	}

	result := config.DB.Where("user_id = ? AND class_id = ?", userID, classID).Delete(&models.ClassMember{})
	if result.RowsAffected == 0 {
		return fmt.Errorf("delete member failed")
	}
	return result.Error
}

func LeaveClass(userID uint, classID uint) error {
	var classInfo models.Class
	if err := config.DB.Where("id = ? AND host_user_id = ?", classID, userID).First(&classInfo).Error; err == nil {
		return fmt.Errorf("host cannot leave the class")
	}

	result := config.DB.Where("user_id = ? AND class_id = ?", userID, classID).Delete(&models.ClassMember{})
	if result.RowsAffected == 0 {
		return fmt.Errorf("leave class failed")
	}
	return result.Error
}
