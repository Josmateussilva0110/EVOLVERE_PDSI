const moment = require('moment')

function formatDateForMySQL(dateStr) {
  if (!dateStr) return null
  return moment(dateStr).format('YYYY-MM-DD HH:mm:ss')
}


module.exports = formatDateForMySQL
