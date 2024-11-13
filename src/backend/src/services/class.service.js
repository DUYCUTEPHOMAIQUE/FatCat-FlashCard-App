'use strict'

const { pick } = require("lodash")
const { NotFoundError, BadRequestError } = require("../core/error.response")
const { ClassModel, ClassMember, User } = require("../models")
const { createUniqueInviteCode } = require("../utils")
 
class ClassService {
    static createClass = async({name, description, userId }) => {
        console.log("name, description, userId::", name, description, userId)
        if(!name || !description || !userId) {
            throw new BadRequestError("Name, description or userId is required")
        }
        
        const inviteCode = await createUniqueInviteCode();
        if(!inviteCode)
            throw new BadRequestError("create invite code failed")

         const newClass = await ClassModel.create({
            name: name,
            description: description,
            code_invite: inviteCode,
            host_user_id: userId,
            member_count: 1,
        })
        if(!newClass)
            throw new BadRequestError("Create class failed")

        const newMember = await ClassMember.create({
            user_id: userId,
            class_id: newClass.id,
            role: "host",
        })
        if(!newMember)
            throw new NotFoundError("Create member failed")
   
        return {
            class: pick(newClass, ["id", "name", "description", "code_invite"]),
            member: pick(newMember, ["id", "user_id", "class_id", "role"]),
        }
    }
    static getClassesForHost = async({userId}) => {
        const classes = await ClassModel.findAll({where: {host_user_id: userId}})
        return classes
    }
    static joinClass = async({userId, codeInvite}) => {
        const foundClass = await ClassModel.findOne({where: {code_invite: codeInvite}})
        if(!foundClass)
            throw new NotFoundError("Class not found")

        const joinedMember = await ClassMember.findOne({where: {user_id: userId, class_id: foundClass.id}})
        if(joinedMember)
            throw new BadRequestError("You have already joined this class")

        const newMember = await ClassMember.create({user_id: userId, class_id: foundClass.id})
        const updatedClass = await ClassModel.update({member_count: foundClass.member_count + 1}, {where: {id: foundClass.id}})
        if(!newMember || !updatedClass)
            throw new BadRequestError("Join class failed")
        return {
            member: pick(newMember, ["id", "user_id", "class_id", "role"]),
        }
    }
   
    static getMembers = async({classId}) => {
        const members = await ClassMember.findAll({
            where: { class_id: classId },
            include: [{
                model: User,
                as: "User",
                attributes: ['id', 'name', 'email']
            }],
            order: [
                ['joined_at', 'ASC']
            ]   
        });

        // làm phẳng data
        const flattenedMembers = members.map(member => ({
            memberId: member.id,
            userId: member.User.id,
            userName: member.User.name,
            userEmail: member.User.email,
            classId: member.class_id,
            role: member.role,
            joinedAt: member.joined_at
        }));

        return {
            memberCount: flattenedMembers.length,
            members: flattenedMembers
        };
    }
    static getAllClasses = async() => {
        const classes = await ClassModel.findAll()
        return classes
    }
    static getClassesByUserId = async({userId, sortBy = "member_count"}) => {
        const order = [];
        
        if (sortBy === 'member_count') {
            order.push([{ model: ClassModel }, 'member_count', 'DESC']);
        } else if (sortBy === 'created_at') {
            order.push([{ model: ClassModel }, 'created_at', 'DESC']);
        } else if (sortBy === 'updated_at') {
            order.push([{ model: ClassModel }, 'updated_at', 'DESC']);
        }

        const classes = await ClassMember.findAll({
            where: { user_id: userId },
            include: [{
                model: ClassModel,
                as: "Class",
                attributes: ['id', 'name', 'description', 'host_user_id', 'member_count', 'code_invite']
            }],
            order: order.length ? order : undefined
        });

        const data = classes.map(item => ({
            id: item.Class.id,
            name: item.Class.name,
            description: item.Class.description,
            host_user_id: item.Class.host_user_id,
            member_count: item.Class.member_count,
            code_invite: item.Class.code_invite,
            role: item.role
        }));
    
        return data;
    }
    static updateClass = async({classId, name, description}) => {
        if(!name || !description)
            throw new BadRequestError("Name or description is required")
        const updatedClass = await ClassModel.update({name, description}, {where: {id: classId}})
        return updatedClass
    }
    static deleteClass = async({classId, userId}) => {
        const deletedClass = await ClassModel.destroy({where: {id: classId, host_user_id: userId}})
        if(!deletedClass)
            throw new BadRequestError("Delete class failed. You are not the host of this class")
        return deletedClass
    }
    static deleteMember = async({userId, classId, hostUserId}) => { 
        const classInfo = await ClassModel.findOne({ where: { id: classId, host_user_id: userId } });
        if (classInfo) {
            throw new BadRequestError("Member cannot delete member");
        }

        const deletedMember = await ClassMember.destroy({where: {user_id: userId, class_id: classId}})
        if(!deletedMember)
            throw new BadRequestError("Delete member failed")
        return deletedMember
    }
    static leaveClass = async({userId, classId}) => {
        const classInfo = await ClassModel.findOne({ where: { id: classId, host_user_id: userId } });
        if (classInfo) {
            throw new BadRequestError("Host cannot leave the class");
        }

        const deletedMember = await ClassMember.destroy({ where: { user_id: userId, class_id: classId } });
        if(!deletedMember)
            throw new BadRequestError("Leave class failed")
        return deletedMember;
    }
}

module.exports = ClassService