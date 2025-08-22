'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
    */

    await queryInterface.bulkInsert('review', [{
      id: 1, 
      order_line_id : "454edc80-3a1c-4ccb-83c8-de45dfe9b12e", 
      rating_star: 4, 
      comment: null, 
      review_date: new Date()
    }, 

    {
      id: 2, 
      order_line_id : "481a3db2-dd87-4bc9-8d2c-f02dff9655ee", 
      rating_star: 5, 
      comment: null, 
      review_date: new Date()
    }, 
  
  ])
  },

  async down (queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
