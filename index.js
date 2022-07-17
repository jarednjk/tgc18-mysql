const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
const mysql2 = require('mysql2/promise');
require ('dotenv').config();

const app = express();
app.set('view engine', 'hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

async function main () {
    const connection = await mysql2.createConnection({
        'host': process.env.DB_HOST, 
        'user': process.env.DB_USER, 
        'database': process.env.DB_DATABASE,
        'password': process.env.DB_PASSWORD
    })

    app.get('/actors', async(req, res)=>{
        const [actors] = await connection.execute("SELECT * FROM actors");

        res.render('actors.hbs',{
            'actors': actors
        })
    })

    app.get('/staffs', async(req,res)=>{
        const [staffs] = await connection.execute("SELECT * FROM staff");
        res.render('staffs.hbs', {
            'staffs': staffs
        })
    })

    app.get('/search', async(req, res)=> {
        let query = "SELECT * from actor where 1";
        let [actors] = await connection.execute(query);

        if (req.query.name) {
            query += `WHERE first_name LIKE '%${req.query.name}%'`
        }

        res.render('search', {
            'actors': actors
        })
    })
    
}

main();

app.use(express.urlencoded({
    'extended': false
}))

app.listen(3000, function (){
    console.log('server has started')
})