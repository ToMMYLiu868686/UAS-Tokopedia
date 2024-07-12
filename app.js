const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Konfigurasi MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Ganti dengan username MySQL Anda
  password: '', // Ganti dengan password MySQL Anda
  database: 'tokopedia' // Ganti dengan nama database Anda
});

// Koneksi ke MySQL
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to MySQL database');
});

// Middleware untuk mengurai body dari request
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Route untuk mendapatkan semua data pengguna
app.get('/api/users', (req, res) => {
  const sql = 'SELECT * FROM user';
  db.query(sql, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});


// Route untuk mendapatkan data pengguna berdasarkan ID
app.get('/api/users/:id', (req, res) => {
  const userId = req.params.id;
  const sql = `SELECT * FROM user WHERE id = ${userId}`;
  db.query(sql, (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
});

// Rute untuk menghapus transaksi
app.delete('/api/transaksi/:id', (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM transaksi WHERE id = ?';
  db.query(sql, [id], (err, result) => {
    if (err) {
	  print(err)
      return res.status(500).send(err);
    }
    return res.status(200).json({ message: 'Task deleted successfully' });
  });
});

app.get('/api/transaksi/:id', (req, res) => {
  const userId = req.params.id;
  const sql = `SELECT * FROM transaksi WHERE id_user = ${userId}`;
  db.query(sql, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.post('/api/auth', (req, res) => {
	const data = req.body;
	const sql = `SELECT * FROM user WHERE email = ? and password = ?`
	db.query(sql, [data.email, data.password], (err, result) => {
		if (err) {
			if (err) throw err;
		};
		if (result.length == 0){
			res.json({"status":false})
		} else {
			res.status(200).json({"id":result[0].id, "status":true});
		}
		// res.json(result);
	})
})

// Route untuk memperbarui data pengguna berdasarkan ID
app.put('/api/users/:id', (req, res) => {
  const { id } = req.params;
  const updateTask = req.body;
  const sql = 'UPDATE user SET ? WHERE id = ?';
  db.query(sql, [updateTask, id], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }
	return  res.status(201).json({ message: 'Sukses Update User' })
  });
});

// Jalankan server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
