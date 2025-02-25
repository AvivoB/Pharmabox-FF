import axios from "axios";

const api = axios.create({
    baseURL: "https://interim-pharmacie.test/api",
});

export default api;