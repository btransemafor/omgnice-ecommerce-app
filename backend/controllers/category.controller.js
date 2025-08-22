
const categoryService = require('../services/category.services'); 

const getAllCategories = async (req,res,next) => {
    categoryService.getAllCategories((error, result) => {
        if (error) {
            return res.status(500).json({message: error.message}); 
            next(error); 
        }

        return res.status(200).json(result);   
    })
}



const updateCategoryByID = (req, res) => {
  const category_id = req.params.id;
  const updateData = req.body;
  console.log(category_id); 

  // Khong dung await cho nay nhe !!!!!

  categoryService.updateCategory({id: category_id, updateData }, (error, result) => {
    
    if (error) {
      return res.status(500).json({ message: error.message });
    }

    if (!result.success) {
      return res.status(404).json({ message: result.message });
    }

    return res.status(200).json(result);
  });
};


const addCategory = (req, res) => {
    categoryService.addCategory(req.body.category_name, (err, result) => {
        if (err) return res.status(500).json({ message: err.message });
      
        if (!result.success) {
          return res.status(409).json(result); // Conflict nếu đã tồn tại
        }
      
        return res.status(201).json(result); // Created thành công
      });
      
}

const deleteCategory = (req, res) => {
    const name_category = req.body.name_category; // hoặc req.query.name_category nếu dùng query param
  
    if (!name_category) {
      return res.status(400).json({ success: false, message: "Thiếu tên danh mục để xoá" });
    }
  
    categoryService.deleteCategory(name_category, (err, result) => {
      if (err) return res.status(500).json({ message: err.message });
      if (!result.success) return res.status(404).json(result);
  
      return res.status(200).json(result);
    });
  };
  

module.exports = {
    getAllCategories, 
    updateCategoryByID, 
    addCategory, 
    deleteCategory
}