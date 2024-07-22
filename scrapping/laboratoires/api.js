const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 7000;

// Route to get data from JSON file
app.get('/api/annuaire', (req, res) => {
	const filePath = path.join(__dirname, 'laboratoires.json');
	fs.readFile(filePath, 'utf8', (err, data) => {
		if (err) {
			console.error('Error reading file:', err);
			return res.status(500).json({ error: 'Internal Server Error' });
		}
		try {
			const labs = JSON.parse(data);
			res.json(labs);
		} catch (parseErr) {
			console.error('Error parsing JSON:', parseErr);
			res.status(500).json({ error: 'Internal Server Error' });
		}
	});
});


// Route to get data from JSON file
app.get('/api/annuaire/:id', (req, res) => {
    const filePath = path.join(__dirname, 'laboratoires.json');
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        try {
            const labs = JSON.parse(data);
            // JSON NOT CONTAINT ID, just array of lab
            const lab = labs.find(lab => labs.indexOf(lab) === parseInt(req.params.id));

            if (!lab) {
                return res.status(404).json({ error: 'Lab not found' });
            }
            res.json(lab);
        } catch (parseErr) {
            console.error('Error parsing JSON:', parseErr);
            res.status(500).json({ error: 'Internal Server Error' });
        }
    });
});



app.listen(port, () => {
	console.log(`Server is running on http://localhost:${port}`);
});