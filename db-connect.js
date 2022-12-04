const {Client} = require('pg');

const query = 'SELECT * FROM services;';


const db_client = new Client({ 
    user: 'postgres', 
    host: 'localhost', 
    database: 'Barbershop', 
    password: '1907', 
    port: 5432, 
    }); 
    
db_client.connect();

async function get_busy(date)
{
    const query_req = `SELECT business.start_time, business.start_time + (( SELECT services.duration FROM services WHERE services.serv_id::text = business.serv_key::text)) AS end_time FROM business WHERE date = '${date}' ORDER BY business.start_time;`
    try{
        let query_res = await db_client.query(query_req)
        return query_res.rows; 
    }catch(err){
        return err;
    }
}

async function get_duration(name)
{
    const query_req = `SELECT serv_id, duration::time without time zone FROM services WHERE name = '${name}';`;
    try{
        let query_res = await db_client.query(query_req)
        return query_res.rows; 
    }catch(err){
        console.log(err);
    }
}

async function get_tags()
{
    const query_req = `SELECT name FROM services;`;
    try{
        let query_res = await db_client.query(query_req)
        return query_res.rows; 
    }catch(err){
        console.log(err);
    }
}

async function sign_up(start_time,date,serv_key,user_name)
{
    const query_req = `INSERT INTO business (start_time, date, serv_key, user_name) VALUES ('${start_time}','${date}','${serv_key}','${user_name}');`;
    try{
        let query_res = await db_client.query(query_req)
        let result = await JSON.stringify(query_res.rows)
        return 'ok'; 
    }catch(err){
        console.log(err);
    }
}

module.exports.get_busy = get_busy;
module.exports.get_duration = get_duration;
module.exports.sign_up = sign_up;
module.exports.get_tags = get_tags;