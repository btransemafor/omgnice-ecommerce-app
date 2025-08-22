const express = require('express'); 
const categoryController = require('../controllers/category.controller'); 
const router = express.Router(); 
const {isAdmin} = require('../middleware/authJwt');  

router.get('/', categoryController.getAllCategories) ;    // category/
router.put('/:id', isAdmin, categoryController.updateCategoryByID); 
router.post('/', isAdmin, categoryController.addCategory ); 
router.delete('/', isAdmin, categoryController.deleteCategory); 
// router.get('/:id', isAdmin, userController.getUserById); 
// router.put('/:id', isAdmin, userController.updateUserByID); 
module.exports = router; 
