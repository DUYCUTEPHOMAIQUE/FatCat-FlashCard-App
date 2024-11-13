'use strict'

const express = require('express')
const expressAsyncHandler = require('express-async-handler')
const router = express.Router()
const ClassController = require('../../controllers/class.controller')
const ClassAccessMiddleware = require('../../middlewares/classaccess.middleware')

// GET
router.get('/', expressAsyncHandler(ClassController.getAllClasses)) //OK
router.get('/own_classes', expressAsyncHandler(ClassController.getClassByUserId)) //OK
router.get('/:class_id/members', expressAsyncHandler(ClassController.getMembersOfClass)) //OK
router.get('/:class_id/decks', expressAsyncHandler(ClassController.getDeckForClass)) //OK
// POST
router.post('/', expressAsyncHandler(ClassController.createClass)) //OK
router.post('/:code_invite', expressAsyncHandler(ClassController.joinClass)) //OK

// DELETE
router.delete('/:class_id', expressAsyncHandler(ClassController.deleteClass)) //OK  
router.delete('/:class_id/members/:user_id', expressAsyncHandler(ClassController.deleteMember)) //OK

// PATCH
router.patch('/:class_id', expressAsyncHandler(ClassController.updateClass)) //OK

// POST Tạo deck cho class
router.post('/:class_id/decks', expressAsyncHandler(ClassController.createDeckForClass)) //OK

// PATCH update deck for class
router.patch('/:class_id/decks/:deck_id', ClassAccessMiddleware.canManageDeck, expressAsyncHandler(ClassController.updateDeckForClass)) // Lỗi

module.exports = router