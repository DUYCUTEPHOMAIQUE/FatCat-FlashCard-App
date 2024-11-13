"use strict"

const ClassModel = require("../models/class.model")
const DeckModel = require("../models/deck.model")
const ClassDeckModel = require("../models/classdeck.model")
const { BadRequestError } = require("../core/error.response")

class DeckForClassService {
    static async createDeckForClass({userId, classId, name, description, categoryId = 1, questionLanguage = "en", answerLanguage = "en"}) {
        if(!userId || !classId || !name || !description)
            throw new BadRequestError("Invalid payload")

        const foundClass = await ClassModel.findOne({where: {id: classId, host_user_id: userId}})
        if(!foundClass)
            throw new BadRequestError("Class not found or you are not the host of this class")
        
        const newDeck = await DeckModel.create({user_id: userId, name, description, category_id: categoryId, question_language: questionLanguage, answer_language: answerLanguage, is_published: true})
        if(!newDeck)
            throw new BadRequestError("Create deck failed")
        
        const newClassDeck = await ClassDeckModel.create({class_id: classId, deck_id: newDeck.id})
        if(!newClassDeck)
            throw new BadRequestError("Create class deck failed")

        return newDeck;
    }     

    static async getDeckForClass(classId) {
        const foundClass = await ClassModel.findOne({where: {id: classId}})
        if(!foundClass)
            throw new BadRequestError("Class not found")
        
        const decks = await ClassDeckModel.findAll({where: {class_id: classId}, include: [{model: DeckModel, as: "Deck"}]})
        if(!decks)
            throw new BadRequestError("No decks found")

        const decksData = decks.map(deck => deck.Deck)
        
        return decksData;
    }
}

module.exports = DeckForClassService;
