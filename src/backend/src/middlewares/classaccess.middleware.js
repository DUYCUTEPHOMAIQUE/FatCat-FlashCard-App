const { ClassMember } = require("../models");
const { BadRequestError } = require("../core/error.response");
const asyncHandler = require("express-async-handler");

class ClassAccessMiddleware {
    static isMemberOfClass = asyncHandler(async (req, res, next) => {
        const userId = req.user.userId;
        const classId = req.params.class_id;

        if (!userId || !classId) {
            throw new BadRequestError("Missing required parameters");
        }

        const member = await ClassMember.findOne({
            where: {
                user_id: userId,
                class_id: classId
            }
        });

        if (!member) {
            throw new BadRequestError("You are not a member of this class");
        }
        req.memberRole = member.role;
        next();
    });

    static isHostOfClass = asyncHandler(async (req, res, next) => {
        if (req.memberRole !== "host") {
            throw new BadRequestError("Only manager can perform this action");
        }
        next();
    });

    static canManageDeck = asyncHandler(async (req, res, next) => {
        if (req.memberRole !== "manager" && req.memberRole !== "host" && req.method !== "GET") {
            throw new BadRequestError("You don't have permission to manage decks");
        }
        next();
    });

    static canManageMembers = asyncHandler(async (req, res, next) => {
        if (req.memberRole !== "host" && req.memberRole !== "manager") {
            throw new BadRequestError("Only host or manager can manage members");
        }
        next();
    });
}

module.exports = ClassAccessMiddleware;