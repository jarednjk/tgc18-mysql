const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
const mysql2 = require('mysql2/promise');
require ('dotenv').config();
require('handlebars-helpers')({
    'handlebars': hbs.handlebars
})

const app = express();
app.set('view engine', 'hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

app.use(express.urlencoded({
    'extended': false
}))

async function main () {
    const connection = await mysql2.createConnection({
        'host': process.env.DB_HOST, 
        'user': process.env.DB_USER, 
        'database': process.env.DB_DATABASE,
        'password': process.env.DB_PASSWORD
    })

    app.get('/categories', async(req, res) => {
        const [categories] = await connection.execute("SELECT * FROM category order by name");

        res.render('categories.hbs', {
            'categories': categories
        })
    })

    app.get('/categories/create', async (req, res) => {
        res.render('create_category');
    })

    app.post('/categories/create', async (req, res) => {
        let categoryName = req.body.name;
        if (categoryName.length <= 25) {
            const query = `insert into category (name) value (?)`;
            await connection.execute(query, [categoryName] );
            res.redirect('/category')
        } else {
            res.status(400);
            res.send('invalid request');
        }
        // const query = "insert into category (name) value (?)";
        // const bindings = [req.body.name];
        // await connection.execute(query, bindings);
        // res.redirect('/category');
    })

    app.get('/categories/:category_id/update', async (req,res) => {
        // const cateogryId = parseInt(req.params.category_id);
        const query = "select * from category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        try {
            const [categories] = await connection.execute(query, bindings);
            const category = categories[0];
            res.render('update_category', {
                'category': category
            })
        } catch (e) {
            
        }
       
    })

    app.post('/categories/:category_id/update', async (req, res) => {
       try {
        const query = `UPDATE category SET name=? WHERE category_id=?`;
        const bindings = [req.body.name, parseInt(req.params.category_id)]
        await connection.execute(query, bindings);
        res.redirect('/categories');
       } catch (e) {
        console.log(e);
        res.redirect('/error')
       }
    })

    app.get('/categories/:category_id/delete', async (req, res) => {
        const query = "SELECT * from category WHERE category_id=?";
        const [categories] = await connection.execute(query, [parseInt(req.params.category_id)]);
        const categoryToDelete = categories[0];
        res.render('confirm_delete_category',{
            'category': categoryToDelete
        })
    })

    app.post('/categories/:category_id/delete', async (req, res) => {
        const deleteQuery = "DELETE FROM film_category where category_id = ?";
        await connection.execute(deleteQuery, [parseInt(req.params.category_id)]);

        const query = "DELETE FROM category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        await connection.execute(query, bindings);
        res.redirect('/categories');
    })

    app.get('/actors', async(req, res)=>{
        const [actors] = await connection.execute("SELECT * FROM actor");

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
        let bindings = [];

        if (req.query.first_name) {
            query += `AND first_name LIKE ?`
            bindings.push('%' + req.query.first_name + '%')
        }

        if (req.query.last_name) {
            query += `AND last_name LIKE ?`
            bindings.push('%' + req.query.last_name + '%')
        }

        let [actors] = await connection.execute(query, bindings);

        res.render('search', {
            'actors': actors
        })
    })
    
    app.get('/actors/create', async (req, res)=>{
        res.render('create_actor')
    })

    app.post('/actors/create', async (req,res)=>{
         // insert into actor (first_name, last_name)
         const query = "insert into actor (first_name, last_name) values ('?', '?')";
         const bindings = [req.body.first_name, req.body.last_name];
         await connection.execute(query, bindings);
         res.redirect('/actors');
    })

    app.get('/actors/:actor_id/update', async(req, res) => {
        const actor_id = parseInt(req.params.actor_id);
        const query = "select * from actor where actor_id = ?";
        const [actors] = await connection.execute(query, [actorId]);
        const actorToUpdate = actors[0];
        res.render('update_actor', {
            'actor': actorToUpdate
        })
    })

    app.post('/actors/:actor_id/update', async (req,res) => {

        if (req.body.first_name.length > 45 || req.body.last_name.length > 45) {
            res.status(400);
            res.send('invalid request');
            return;
        }

        // sample query
        // update actor set first_name="zoe2", last_name="tay2" WHERE actor_id = 202;
        const query = `update actor set first_name=?, last_name=? WHERE actor_id = ?`
        const bindings = [req.body.first_name, req.body.last_name, parseInt(req.params.actor_id)];
        await connection.execute(query, bindings);
        req.redirect('/actors');
    })

    app.post('/actors/:actor_id/delete', async (req, res) => {
        const query = "DELETE FROM actor WHERE actor_id = ?";
        const bindings = [parseInt(req.params.actor_id)];
        await connection.execute(query, bindings);
        res.redirect('/actors');
    })

    // film
    app.get('/films', async (req, res) => {
        const [films] = await connection.execute(`SELECT film_id, title, description, language.name AS 'language' FROM film JOIN language on film.language_id = language.language_id`)
        res.render('films', {
            'films': films
        })
    })

    app.get('/films/create', async (req, res) => {
        const [languages] = await connection.execute(
            "SELECT * FROM language"
        );
        res.render('create_film', {
            languages: languages
        })
    })

    app.post('/films/create', async (req, res) => {
        await connection.execute(
            `insert into FileSystem(title, description, language_id) values (?, ?, ?)`,
            [req.body.title, req.body.description, req.body.language_id]
        );
        res.redirect('/films');
    })

    app.get('/films/:film_id/update', async (req, res) => {
        const [languages] = await connection.execute("SELECT * FROM language ")
        const [films] = await connection.execute("SELECT * from film where film_id = ?",
            [parseInt(req.params.film_id)]);
        const filmToUpdate = films[0];
        res.render('update_film',{
            'film': filmToUpdate,
            'languages': languages
        })
    })

    app.post('/films/:film_id/update', async (req, res) => {
        await connection.execute(
            `UPDATE film SET title=?,
                             description=?,
                             language_id=?
                             WHERE film_id=?`,
            [req.body.title, req.body.description, parseInt(req.body.language_id), req.params.film_id]
        );
        res.redirect('/films');
    })
}

main();

app.use(express.urlencoded({
    'extended': false
}))

app.listen(3000, function (){
    console.log('server has started')
})