import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { QueryClient, QueryClientProvider } from 'react-query';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Users from './Pages/Users';
import Login from './Pages/Login';
import Pharmacies from './Pages/Pharmacies';
import Annuaire from './Pages/Annuaire';
import Newsletter from './Pages/Newsletter';
import Pharmablabla from './Pages/Pharmablabla';
import AppMessage from './Pages/AppMessage';


const queryClient = new QueryClient();
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login/>} />
        <Route path="/login" element={<Login/>} />
        <Route path="/users" element={<Users/>} />
        <Route path="/pharmacies" element={<Pharmacies/>} />
        <Route path="/annuaire" element={<Annuaire/>} />
        <Route path="/newslettter" element={<Newsletter/>} />
        <Route path="/app-message" element={<AppMessage/>} />
        <Route path="/pharmablabla" element={<Pharmablabla/>} />
      </Routes>
    </BrowserRouter>
    </QueryClientProvider>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
