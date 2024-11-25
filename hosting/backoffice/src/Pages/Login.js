import React, { useState } from 'react';
import { Form, Input, Button, Checkbox, Alert } from 'antd';
import axios from 'axios';
import { getImage } from '../common-functions';

const Login = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const onFinish = async (values) => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.post(`${process.env.REACT_APP_API_URL}/login`, {
        email: values.email,
        password: values.password,
      });
      console.log('Login successful:', response.data);

      // save token in local storage
      localStorage.setItem('token_pharmabox', response.data.token);
      // Rediriger ou effectuer une autre action après un login réussi
    } catch (err) {
      setError(err.response ? err.response.data.message : 'Identifiants incorrects');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex justify-center items-center h-screen bg-gray-100">
      <div className="w-96 p-8 bg-white rounded-lg shadow-lg">
        <div>
          <img src={getImage('Logo SVG Pharmabox.svg')} alt=""/>
          <h2 className="text-2xl font-semibold text-center mb-6">Backoffice</h2>
        </div>
        {error && <Alert message={error} type="error" showIcon className="mb-6" />}
        <Form
          name="login"
          initialValues={{ remember: true }}
          onFinish={onFinish}
        >
          <Form.Item
            name="email"
            rules={[{ required: true, message: 'Entrez un email' }]}
          >
            <Input placeholder="Email" />
          </Form.Item>

          <Form.Item
            name="password"
            rules={[{ required: true, message: 'Entrez un mot de passe' }]}
          >
            <Input.Password placeholder="Password" />
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" loading={loading} block>
              Connexion
            </Button>
          </Form.Item>
        </Form>
      </div>
    </div>
  );
};

export default Login;