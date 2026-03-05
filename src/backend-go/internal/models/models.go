package models

import (
	"time"
)

// User model
type User struct {
	ID            uint       `gorm:"primaryKey;autoIncrement" json:"id"`
	Name          string     `gorm:"size:191;not null" json:"name"`
	Email         string     `gorm:"size:191;not null;uniqueIndex" json:"email"`
	Password      string     `gorm:"not null" json:"-"`
	RoleSystem    string     `gorm:"type:enum('user','admin');default:'user'" json:"role_system"`
	RoleGroup     string     `gorm:"type:enum('leader','member');default:'member'" json:"role_group"`
	Status        string     `gorm:"type:enum('active','inactive');default:'active'" json:"status"`
	StreakLength   int        `gorm:"default:0" json:"streak_length"`
	StreakStartAt  *time.Time `json:"streak_start_at"`
	StreakEndAt    *time.Time `json:"streak_end_at"`
	Score         int        `gorm:"default:0" json:"score"`
	LastReviewedAt *time.Time `json:"last_reviewed_at"`
	IsVerified    bool       `gorm:"default:false" json:"isVerified"`
	Avatar        []byte     `gorm:"type:mediumblob" json:"avatar,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

// Category model
type Category struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Name      string    `gorm:"not null" json:"name"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// Deck model
type Deck struct {
	ID               uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	UserID           uint      `gorm:"index" json:"user_id"`
	Name             string    `gorm:"not null" json:"name"`
	Description      string    `gorm:"type:text" json:"description"`
	CategoryID       *uint     `json:"category_id"`
	IsPublished      bool      `gorm:"default:true" json:"is_published"`
	DeckCardsCount   int       `gorm:"default:0" json:"deck_cards_count"`
	QuestionLanguage string    `gorm:"type:text;default:'en'" json:"question_language"`
	AnswerLanguage   string    `gorm:"type:text;default:'en'" json:"answer_language"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
	// Relations
	User     *User     `gorm:"foreignKey:UserID" json:"User,omitempty"`
	Category *Category `gorm:"foreignKey:CategoryID" json:"Category,omitempty"`
	Cards    []Card    `gorm:"foreignKey:DeckID" json:"Cards,omitempty"`
}

// Card model
type Card struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	DeckID    uint      `gorm:"index" json:"deck_id"`
	Question  string    `gorm:"type:text;not null" json:"question"`
	Answer    string    `gorm:"type:text;not null" json:"answer"`
	Image     []byte    `gorm:"type:blob" json:"image,omitempty"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// Class model
type Class struct {
	ID          uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Name        string    `gorm:"not null" json:"name"`
	Description string    `gorm:"type:text" json:"description"`
	HostUserID  uint      `json:"host_user_id"`
	MemberCount int       `gorm:"default:0" json:"member_count"`
	CodeInvite  string    `json:"code_invite"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// ClassMember model
type ClassMember struct {
	ID       uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	UserID   uint      `json:"user_id"`
	ClassID  uint      `json:"class_id"`
	Role     string    `gorm:"default:'member'" json:"role"`
	JoinedAt time.Time `gorm:"autoCreateTime" json:"joined_at"`
	// Relations
	User  *User  `gorm:"foreignKey:UserID" json:"User,omitempty"`
	Class *Class `gorm:"foreignKey:ClassID" json:"Class,omitempty"`
}

// ClassDeck model
type ClassDeck struct {
	ID      uint `gorm:"primaryKey;autoIncrement" json:"id"`
	ClassID uint `json:"class_id"`
	DeckID  uint `json:"deck_id"`
	// Relations
	Deck *Deck `gorm:"foreignKey:DeckID" json:"Deck,omitempty"`
}

// Token model
type Token struct {
	ID          uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	UserID      uint      `json:"userId"`
	AccessToken string    `gorm:"not null" json:"accessToken"`
	ExpiresAt   time.Time `json:"expiresAt"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// OTP model
type OTP struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	UserID    uint      `json:"userId"`
	OtpCode   string    `gorm:"size:6;not null" json:"otpCode"`
	ExpiresAt time.Time `gorm:"not null" json:"expiresAt"`
	IsUsed    bool      `gorm:"default:false" json:"isUsed"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// Image model
type Image struct {
	ID   uint   `gorm:"primaryKey;autoIncrement" json:"id"`
	Data []byte `gorm:"type:longblob" json:"data"`
}

// Table name overrides (to match Node.js Sequelize table names)
func (User) TableName() string        { return "Users" }
func (Category) TableName() string    { return "Categories" }
func (Deck) TableName() string        { return "Decks" }
func (Card) TableName() string        { return "Cards" }
func (Class) TableName() string       { return "Classes" }
func (ClassMember) TableName() string { return "ClassMembers" }
func (ClassDeck) TableName() string   { return "ClassDecks" }
func (Token) TableName() string       { return "Tokens" }
func (OTP) TableName() string         { return "OTPs" }
func (Image) TableName() string       { return "Images" }
