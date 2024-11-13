"use strict";

const { SuccessResponse } = require("../core/success.response");
const ClassService = require("../services/class.service");
const DeckService = require("../services/deck.service");
const DeckForClassService = require("../services/deckforclass.service");
class ClassController {
  async createClass(req, res) {
    new SuccessResponse({
      message: "Create class successfully",
      metadata: await ClassService.createClass({
        ...req.body,
        ...req.user,
      }),
    }).send(res);
  }
  async getAllClasses(req, res) {
    new SuccessResponse({
      message: "Get all classes successfully",
      metadata: await ClassService.getAllClasses(),
    }).send(res);
  }
  async getClassByUserId(req, res) {
    new SuccessResponse({
      message: "Get class by user id successfully",
      metadata: await ClassService.getClassesByUserId({
        userId: req.user.userId,
        sortBy: req.query.sortBy,
      }),
    }).send(res);
  }

  async joinClass(req, res) {
    new SuccessResponse({
      message: "Join class successfully",
      metadata: await ClassService.joinClass({
        userId: req.user.userId,
        codeInvite: req.params.code_invite,
      }),
    }).send(res);
  }
  async leaveClass(req, res) {
    new SuccessResponse({
      message: "Leave class successfully",
      metadata: await ClassService.leaveClass({
        userId: req.user.userId,
        classId: req.params.class_id,
      }),
    }).send(res);
  }
  async deleteClass(req, res) {
    new SuccessResponse({
      message: "Delete class successfully",
      metadata: await ClassService.deleteClass({
        classId: req.params.class_id,
        userId: req.user.userId,
      }),
    }).send(res);
  }
  async updateClass(req, res) {
    new SuccessResponse({
      message: "Update class successfully",
      metadata: await ClassService.updateClass(req.body),
    }).send(res);
  }
  async getMembersOfClass(req, res) {
    new SuccessResponse({
      message: "Get members of class successfully",
      metadata: await ClassService.getMembers({ classId: req.params.class_id }),
    }).send(res);
  }
  async deleteMember(req, res) {
    new SuccessResponse({
      message: "Delete member successfully",
      metadata: await ClassService.deleteMember({
        userId: req.params.user_id,
        classId: req.params.class_id,
        hostUserId: req.user.userId,
      }),
    }).send(res);
  }

  async createDeckForClass(req, res) {
    new SuccessResponse({
      message: "Create deck for class successfully",
      metadata: await DeckForClassService.createDeckForClass({
        userId: req.user.userId,
        classId: req.params.class_id,
        ...req.body,
      }),
    }).send(res);
  }

  async getDeckForClass(req, res) {
    new SuccessResponse({
      message: "Get decks for class successfully",
      metadata: await DeckForClassService.getDeckForClass(req.params.class_id),
    }).send(res);
  }

  async updateDeckForClass(req, res) {
    const { deck, cards } = req.body;
    const deckId = req.params.deckId;
    const { userId } = req.user;
    return new SuccessResponse({
      message: "Update deck successfully.",
      metadata: await DeckService.updateDeck({
        deckId,
        deckData: deck,
        cards,
        userId,
      }),
    }).send(res);
  }
}

module.exports = new ClassController();
