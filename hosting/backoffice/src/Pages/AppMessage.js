import React, { useRef, useState } from 'react';
import Layout from '../Components/Layout';
import { useQuery } from 'react-query';
import { Button, Card, ColorPicker, Form, Input, Modal, Select, Spin, Typography } from 'antd';
import EmailEditor from 'react-email-editor';
import { createTemplate, loadPharmacies, loadTemplates, loadUsers } from '../common-functions';
import create from '@ant-design/icons/lib/components/IconFont';
import { useForm } from 'antd/es/form/Form';
import axios from 'axios';

// Destructuration des composants Ant Design
const { Title, Text } = Typography;

const AppMessage = () => {
  // Gestion des données via React Query
  const { formProps, saveButtonProps } = useForm();


  const onFinish = (values) => {
    axios.post(`${process.env.REACT_APP_API_URL}/change-dynamic-message`, {

      title: values.title,
      text: values.message,
      color1: values.color1,
      color2: values.color2,
      button_text: values.button_text,
      link: values.url
    }, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
      }
    }).then(response => {
      console.log(response.data);
    }
    )
  }
  const setEmptyMessage = () => {
    axios.post(`${process.env.REACT_APP_API_URL}/change-dynamic-message`, {

      title: '',
      text: '',
      color1: '',
      color2: '',
      button_text: '',
      link: ''
    }, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
      }
    }).then(response => {
      console.log(response.data);
    }
    )
  }

  return (
    <Layout>
      {/* Titre principal */}
      <Title level={2} className="mb-4">
        Modifier le message dynamique de l'application
      </Title>

      <div className='py-4'>
        <Button onClick={() => setEmptyMessage()}>Vider le message dans l'application</Button>
      </div>

      <Form {...formProps} layout='vertical' onFinish={onFinish}>
        <Form.Item
          label="Titre"
          name="title"
          rules={[{ required: true, message: 'Veuillez saisir le titre' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Message"
          name="message"
          rules={[{ required: true, message: 'Veuillez saisir le message' }]}
        >
          <Input.TextArea />
        </Form.Item>
        <Form.Item
          label="Couleur 1"
          name="color1"
          getValueFromEvent={(color) => {
            return  color.toHex();
          }}
          rules={[{ required: true, message: 'Veuillez saisir la couleur' }]}
        >
          <ColorPicker defaultValue="#1677ff" size="small" showText />
        </Form.Item>
        <Form.Item
          label="Couleur 2"
          name="color2"
          getValueFromEvent={(color) => {
            return  color.toHex();
          }}
          rules={[{ required: true, message: 'Veuillez saisir la couleur' }]}
        >
          <ColorPicker defaultValue="#1677ff" size="small" showText />
        </Form.Item>

        <Form.Item
          label="Lien du bouton"
          name="url"
          rules={[{ required: true, message: 'Veuillez saisir une url' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Texte du bouton"
          name="button_text"
          rules={[{ required: true, message: 'Veuillez saisir un texte' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item>
          <Button type="primary" htmlType="submit">
            Enregistrer
          </Button>
        </Form.Item>
      </Form>

      
    </Layout>
  );
};

export default AppMessage;
