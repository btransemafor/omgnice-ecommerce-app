
module.exports = (sequelize, Datatype) => {
    const userPromotion = sequelize.define('UserPromotion', {
        'id' : {
            type: Datatype.UUID, // Phải là UUID chứ không phải STRING
            defaultValue: Datatype.UUIDV4, // Sinh tự động UUID
            primaryKey: true,
        },  

        // Add Constraints unique 
        'user_id' : {
            type: Datatype.UUID, 
            allowNull: false, 
            unique: 'user_promotion_unique_constraint'
        }, 
        'promotion_id': {
            type: Datatype.INTEGER, 
            allowNull: false, 
            unique: 'user_promotion_unique_constraint'
        }, 

    })
    return userPromotion; 
}