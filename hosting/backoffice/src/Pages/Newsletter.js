import React, { useRef, useState } from 'react';
import Layout from '../Components/Layout';
import { useQuery } from 'react-query';
import { Button, Card, Form, Input, message, Modal, Select, Spin, Typography } from 'antd';
import EmailEditor from 'react-email-editor';
import { createTemplate, loadPharmacies, loadTemplates, loadUsers } from '../common-functions';
import create from '@ant-design/icons/lib/components/IconFont';
import axios from 'axios';

// Destructuration des composants Ant Design
const { Title, Text } = Typography;

const Newsletter = () => {
  // Gestion des données via React Query
  const { isLoading: isLoadingPharmacies, data: pharmacies } = useQuery('pharmacies', loadPharmacies);
  const { isLoading: isLoadingUsers, data: users } = useQuery('users', loadUsers);
  const { isLoading: isLoadingTemplate, data: templates } = useQuery('templates', loadTemplates);

  const emailEditorRef = useRef(null);

  const [modalSaveTemplate, setmodalSaveTemplate] = useState(false);
  const [messageApi, contextHolder] = message.useMessage();


  const dynamicData = ['{{nom}}', '{{prenom}}', '{{poste}}'];

  const [selectCondition, setSelectCondition] = useState([
    {
        label: 'Tous les utilisateurs', 
        value: 'all',
        items: []
    },
    {
        label: 'Profil', 
        value: 'isComplete',
        items: [{label: 'Complet', value: 'true'}, {label: 'Incomplet', value: 'false'}]
    },
    {
        label: 'Poste', 
        value: 'poste',
        items: [
            {label: 'Pharmacien titulaire', value: 'Pharmacien titulaire'}, 
            {label: 'Pharmacien', value: 'Pharmacien'},
            {label: 'Préparateur', value: 'Préparateur'},
            {label: 'Rayonniste', value: 'Rayonniste'},
            {label: 'Conseiller', value: 'Conseiller'},
            {label: 'Apprenti', value: 'Apprenti'},
            {label: 'Etudiant pharmacie', value: 'Etudiant pharmacie'},
            {label: 'Etudiant pharmacie 6ème année validée', value: 'Etudiant pharmacie 6ème année validée'},
        ]
    },
    {
        label: 'Photo de profil', 
        value: 'photoUrl',
        items: [{label: 'Sans photo', value: ''}]
    },
    {
        label: 'Méthode de connexion',
        value: 'authMethod',
        items: [{label: 'E-mail', value: 'password'}, {label: 'Google', value: 'google.com'}, {label: 'Apple', value: 'apple.com'}]
    }
  ]);

  const setActiveCondition = (condition) => {
    setSelectCondition(selectCondition.map((item) => {
        if (item.value === condition) {
            return {...item, active: true};
        }
        return {...item, active: false};
    }));
  };
  
  const [templateSelectd, settemplateSelectd] = useState(null);

  // const changeTemplate = (value) => {
  //   settemplateSelectd(value);

  //   const unlayer = emailEditorRef.current?.editor;
  //       unlayer.loadDesign(templates.templates.find((template) => template.name === value).data_editor);
  //   };


//   const saveTemplate = async (values) => {
//     console.log('save form')
//     const unlayer = emailEditorRef.current?.editor;
//     var html = '';
//     var editor = '';

//     unlayer?.exportHtml( (data) => {
//         html = data.html;
//         editor = data.design;
//     });

//     await createTemplate({
//         name: values.name,
//         data_editor: JSON.stringify(editor),
//         html: html,
//     });


//  };

 const sendNewsletter = async (values) => {
    const unlayer = emailEditorRef.current?.editor;

    unlayer?.exportHtml( (data) => {
        const html = data.html;
        const editor = data.design;

        let mails = '';

        if(values.email_test != '' && values.email_test != null) {
            mails = values.email_test;
            console.log(mails);
        } else {
            if(values.first_condition == "all") {
              var usersNotif = users.filter(user => user.email);
              mails = usersNotif.map(user => user.email).join(',');
              console.log(mails);
          } else {
              console.log(values.first_condition);
              console.log(values.second_condition);
              var usersNotif = users.filter(user => user[values.first_condition] === values.second_condition && user.email);
              mails = usersNotif.map(user => user.email).join(',');
              console.log(mails);
          }
        }
        
        axios.post(`${process.env.REACT_APP_API_URL}/send-newsletter`, {
            subject: values.subject,
            html: html,
            emails: mails,
        }, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        }).then(response => {
            console.log(response.data);
            if(response.data.message==='Emails envoyés avec succès.'){
                messageApi.open({
                    type: 'success',
                    content: 'La newsletter à été envoyée avec succès à ' + mails.split(',').length + ' destinataires',
                });
            }
      });
    });


};

  if (isLoadingPharmacies || isLoadingUsers || isLoadingTemplate) {
    return (
      <div className="flex justify-center items-center h-screen">
        <Spin size="large" />
      </div>
    );
  }

  return (
    <Layout>
      {contextHolder}
      {/* Titre principal */}
      <Title level={2} className="mb-4">
        Envoyer des Newsletters
      </Title>
      <Card className="mb-6" bordered>
        <Title level={3}>1. Créez le template</Title>
        <div className="mt-6">
          <Title level={4}>Éléments dynamiques disponibles</Title>
          <ul className="list-disc pl-6">
            {dynamicData.map((item, index) => (
              <li key={index}>{item}</li>
            ))}
          </ul>
        </div>

        <div className="mt-6">
          <EmailEditor ref={emailEditorRef} />
        </div>
      </Card>

      {/* Section 2 : Choisir les destinataires */}
      <Card className="mb-6" bordered>
        <Title level={3}>2. Sélectionnez les destinataires</Title>
        <Form layout="vertical" onFinish={sendNewsletter}>
          <Form.Item
            name="subject"
            label="Sujet de la Newsletter"
            rules={[{ required: true, message: 'Entrez un sujet' }]}
          >
            <Input placeholder="Exemple : Promotion spéciale de novembre" />
          </Form.Item>

          <Form.Item name="first_condition" label='Cibler'>
            <Select placeholder="Sélectionner une valeur" onChange={(e) => setActiveCondition(e)}>
                {selectCondition.map((item) => (
                <Select.Option key={item.value} value={item.value} active={item.active ? true : false} >
                    {item.label}
                </Select.Option>
                ))}
            </Select>
            </Form.Item>
            {selectCondition.find(el => el.active === true) && selectCondition.find(el => el.active === true).items.length > 0 &&
            <Form.Item name={'second_condition'} label='Qui est '>
                <Select placeholder="Sélectionner une valeur" onChange={() => console.log()}>
                {selectCondition.find(el => el.active === true)  && selectCondition.find(el => el.active === true).items.map((item) => (
                    <Select.Option key={item.value} value={item.value}>
                        {item.label}
                    </Select.Option>
                ))}
                </Select>
            </Form.Item>
            }
          <Form.Item
            name="email_test"
            className="flex items-center mt-4"
          >
                <Input
                type="email"
                placeholder="pour ajouter plusieurs emails, séparez les par une virgule"
                className="mr-4"
                style={{ width: 400 }}
                />
            </Form.Item>
            <small>Si ce champ est rempli, le mail ne sera envoyé qu'à cette adresse, pour envoyer la Newsletter, vider les emails de test</small>
            <Form.Item>
            <Button type="primary" htmlType="submit">
                Envoyer la Newsletter
            </Button>
            </Form.Item>
        </Form>
      </Card>
    </Layout>
  );
};

export default Newsletter;
