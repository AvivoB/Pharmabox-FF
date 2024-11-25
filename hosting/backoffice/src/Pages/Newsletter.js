import React, { useRef, useState } from 'react';
import Layout from '../Components/Layout';
import { useQuery } from 'react-query';
import { Button, Card, Form, Input, Modal, Select, Spin, Typography } from 'antd';
import EmailEditor from 'react-email-editor';
import { createTemplate, loadPharmacies, loadTemplates, loadUsers } from '../common-functions';
import create from '@ant-design/icons/lib/components/IconFont';

// Destructuration des composants Ant Design
const { Title, Text } = Typography;

const Newsletter = () => {
  // Gestion des données via React Query
  const { isLoading: isLoadingPharmacies } = useQuery('pharmacies', loadPharmacies);
  const { isLoading: isLoadingUsers } = useQuery('users', loadUsers);
  const { isLoading: isLoadingTemplate, data: templates } = useQuery('templates', loadTemplates);

  const emailEditorRef = useRef(null);

  const [modalSaveTemplate, setmodalSaveTemplate] = useState(false);


  const dynamicData = ['{{nom}}', '{{prenom}}', '{{poste}}'];

  const [selectCondition, setSelectCondition] = useState([
    {
      label: 'Tous les utilisateurs',
      type: 'users',
    },
    {
      label: 'Profil',
      type: 'users',
      name: 'isComplete',
      items: [
        { label: 'Complet', value: 'true' },
        { label: 'Incomplet', value: 'false' },
      ],
    },
    {
      label: 'Poste',
      type: 'users',
      value: 'poste',
      items: [
        { label: 'Pharmacien titulaire', value: 'Pharmacien titulaire' },
        { label: 'Préparateur', value: 'Préparateur' },
      ],
    },
    {
      label: 'Utilisateurs sans photo',
      type: 'users',
      value: 'photoUrl',
      items: [{ label: 'Sans photo', value: '' }],
    },
  ]);

  const setActiveCondition = (condition) => {
    setSelectCondition(
      selectCondition.map((item) => ({
        ...item,
        active: item.value === condition,
      }))
    );
  };
  
  const [templateSelectd, settemplateSelectd] = useState(null);

  const changeTemplate = (value) => {
    settemplateSelectd(value);

    const unlayer = emailEditorRef.current?.editor;
        unlayer.loadDesign(templates.templates.find((template) => template.name === value).data_editor);
    };
  const startEditorEmail = () => {
    // unlayer.loadDesign();
  };

  const saveTemplate = async (values) => {
    console.log('save form')
    const unlayer = emailEditorRef.current?.editor;
    var html = '';
    var editor = '';

    unlayer?.exportHtml( (data) => {
        html = data.html;
        editor = data.design;
    });

    await createTemplate({
        name: values.name,
        data_editor: JSON.stringify(editor),
        html: html,
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
      {/* Titre principal */}
      <Title level={2} className="mb-4">
        Envoyer des Newsletters
      </Title>

      <Modal open={modalSaveTemplate} footer={null} onClose={() => setmodalSaveTemplate(false)} onCancel={() => setmodalSaveTemplate(false)}>
        <Title level={3}>Sauvegarder le template</Title>
        <Form layout="vertical" onFinish={saveTemplate}>
            <Form.Item
                name={['template', 'name']}
                label="Nom du template"
                rules={[{ required: true, message: 'Entrez un nom de template' }]}
            >
                <Input placeholder="Exemple : Promotion de novembre" defaultValue={templateSelectd} />
            </Form.Item>
        </Form>
        <Button type="primary" htmlType='submit'>Sauvegarder</Button>

      </Modal>

      {/* Section 1 : Choisir un template */}
      <Card className="mb-6" bordered>
        <Title level={3}>1. Créez le template</Title>
        {/* <div className="mt-4 flex items-center gap-4">
          <Select
            placeholder="Sélectionnez un template existant"
            onChange={(value) => changeTemplate(value)}
          >
            {templates?.templates.map((template, index) => (
              <Select.Option key={index} value={template.name}>
                {template.name}
              </Select.Option>
            ))}
          </Select>
          <Button type="primary" onClick={() => setmodalSaveTemplate(true)}>
            Sauvegarder le template
          </Button>
        </div> */}

        <div className="mt-6">
          <Title level={4}>Éléments dynamiques disponibles</Title>
          <ul className="list-disc pl-6">
            {dynamicData.map((item, index) => (
              <li key={index}>{item}</li>
            ))}
          </ul>
        </div>

        <div className="mt-6">
          <EmailEditor ref={emailEditorRef} onReady={startEditorEmail} />
        </div>
      </Card>

      {/* Section 2 : Choisir les destinataires */}
      <Card className="mb-6" bordered>
        <Title level={3}>2. Sélectionnez les destinataires</Title>
        <Form layout="vertical">
          <Form.Item
            name="subject"
            label="Sujet de la Newsletter"
            rules={[{ required: true, message: 'Entrez un sujet' }]}
          >
            <Input placeholder="Exemple : Promotion spéciale de novembre" />
          </Form.Item>

          <Form.Item name="first_condition" label="Condition principale">
            <Select
              placeholder="Sélectionnez une condition"
              onChange={setActiveCondition}
            >
              {selectCondition.map((item) => (
                <Select.Option key={item.value} value={item.value}>
                  {item.label}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <Form.Item
            name="second_condition"
            label="Condition secondaire"
            dependencies={['first_condition']}
          >
            <Select
              placeholder="Sélectionnez une valeur"
              disabled={
                !selectCondition.some((item) => item.active && item.items)
              }
            >
              {selectCondition
                .find((el) => el.active)
                ?.items.map((item) => (
                  <Select.Option key={item.value} value={item.value}>
                    {item.label}
                  </Select.Option>
                ))}
            </Select>
          </Form.Item>
          {/* Envoyer et envoyer un mail de test */}
          <Form.Item>
            
            <div className="flex items-center mt-4">
                <Input
                type="email"
                placeholder="Entrez un email pour le test"
                className="mr-4"
                style={{ width: 250 }}
                required
                />
                <Button type="default">
                    Envoyer un mail de test
                </Button>
            </div>
            </Form.Item>
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
