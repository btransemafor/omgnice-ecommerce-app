const express = require('express'); 

const router = express.Router(); 

const addressController = require('../controllers/address.controller'); 
const { isAdmin } = require('../middleware');

router.post('/', addressController.createnewAddress); 
router.put('/:id', addressController.updateAddress);
router.get('/',addressController.fetchListAddress); 
router.get('/',addressController.fetchListAddress); 
router.get('/:id',isAdmin,addressController.fetchListAddress); 
router.delete('/:id', addressController.deleteAddress); 
module.exports = router; 