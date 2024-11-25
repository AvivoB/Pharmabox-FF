import axios from "axios";

// Load image from public folder
export const getImage = (image) => {
    return process.env.PUBLIC_URL + '/public/' + image;
}


export const loadUsers = async () => {
    try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/users`, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        return response.data;
    }
    catch (error) {
        window.location.href = '/login';
    }
}

export const loadPharmacies = async () => {
    try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/pharmacies`, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        return response.data;
    } catch (error) {
        window.location.href = '/login';
    }
}

export const createNotification = async (fcmToken, title, body) => {


    // transform the fcmToken into separate by comma string

    const response = await axios.post(`${process.env.REACT_APP_API_URL}/create-notification`, {
        token: fcmToken,
        body: body,
        title: title
    }, {
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
        }
    });
    return response.data;
}


export const loadTemplates = async () => {
    try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/templates`, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        console.log('templates', response.data.templates);
        return response.data;
    } catch (error) {
        window.location.href = '/login';
    }
}

export const createTemplate = async (data) => {
    try {
        const response = await axios.post(`${process.env.REACT_APP_API_URL}/create-template`, {
            html: data.html,
            editor_data: data.editor_data,
            name: data.name

        }, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        console.log(response.data);
        return response.data;
    } catch (error) {
        window.location.href = '/login';
    }
}

export const loadAnnuaire = async () => {
    try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/annuaire`, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        return response.data;
    } catch (error) {
        window.location.href = '/login';
    }
}

export const loadPharmablabla = async () => {
    try {
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/pharmablabla`, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        });
        return response.data;
    } catch (error) {
        window.location.href = '/login';
    }
}