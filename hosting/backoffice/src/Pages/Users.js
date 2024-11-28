import React, { act, useEffect, useMemo, useState } from 'react'
import Layout from '../Components/Layout'
import { Badge, Card, Table, Statistic, Spin, Tag, Select, Modal, Button, Form, Alert } from 'antd'
import { AppleOutlined, GoogleOutlined, MailOutlined } from '@ant-design/icons';
import { Line } from '@ant-design/charts';
import { useQuery } from 'react-query';
import { createNotification, loadUsers } from '../common-functions';
import Input from 'antd/es/input/Input';

const Users = () => {

    const {isLoading, error, data} = useQuery('users', () => loadUsers());
    const users = data || [];
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear()); // Année sélectionnée (par défaut, l'année actuelle)

    const [setSelectedUser, selectedUsers] = useState();

    const columns = [
        {
            title: 'Photo',
            dataIndex: 'photoUrl',
            key: 'photoUrl',
            // responsive: ['lg'],
            render : (photoUrl) => photoUrl ? <img src={photoUrl} alt='user' className='rounded-full max-w-12' /> : null
        },
        {
            title: 'Nom',
            dataIndex: 'name',
            key: 'name',
            // responsive: ['md'],
            filter: [{filterMode: 'tree', filterSearch: true,
                onFilter: (value, record) => record.name.startsWith(value),}]
        },
        {
            title: 'Email',
            dataIndex: 'email',
            key: 'email',
            // responsive: ['md'],
        },
        {
            title: 'Poste',
            dataIndex: 'poste',
            key: 'poste',
        },
        {
            title: 'Crée le',
            dataIndex: 'created_at',
            key: 'created_at',
        },
        {
            title: 'Profil',
            dataIndex: 'isComplete',
            key: 'isComplete',
            render: (isComplete) => (
                <Tag color={isComplete ? 'green' : 'red'}>
                    {isComplete ? 'Complet' : 'Incomplet'}
                </Tag>
              ),
        }
    ]

    const monthOrder = [
        'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
        'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
      ];

    // Grouper les utilisateurs par mois et année pour created_at en fonction de l'année sélectionnée
  const userStats = useMemo(() => {
    if (!data) return [];
    const filteredUsers = data.filter((user) => {
      const date = new Date(user.created_at);
      return date.getFullYear() === selectedYear;
    });

    const reduc = filteredUsers.reduce((acc, user) => {
      const date = new Date(user.created_at);
      const month = new Intl.DateTimeFormat('fr-FR', { month: 'long' }).format(date);
      const year = date.getFullYear();
      const key = `${month} ${year}`;
      acc[key] = acc[key] || 0;
      acc[key]++;
      return acc;
    }, {});

    const result = Object.keys(reduc).map((key) => ({
      période: key,
      inscriptions: reduc[key],
    }));

    result.sort((a, b) => {
        const [monthA, yearA] = a.période.split(' ');
        const [monthB, yearB] = b.période.split(' ');
        return (
            parseInt(yearA) - parseInt(yearB) ||
            monthOrder.indexOf(monthA.toLowerCase()) - monthOrder.indexOf(monthB.toLowerCase())
        );
    });

    return result;
  }, [data, selectedYear, isLoading]);


  const userActivity = useMemo(() => {
    if (!data) return [];
    const filteredUsers = data.filter((user) => {
      const date = new Date(user.created_at);
      return date.getFullYear() === selectedYear;
    });

    const reduc = filteredUsers.reduce((acc, user) => {
      const date = new Date(user.last_activity);
      const month = new Intl.DateTimeFormat('fr-FR', { month: 'long' }).format(date);
      const year = date.getFullYear();
      const key = `${month} ${year}`;
      acc[key] = acc[key] || 0;
      acc[key]++;
      return acc;
    }, {});

    const result = Object.keys(reduc).map((key) => ({
      période: key,
      connexions: reduc[key],
    }));

    result.sort((a, b) => {
        const [monthA, yearA] = a.période.split(' ');
        const [monthB, yearB] = b.période.split(' ');
        return (
            parseInt(yearA) - parseInt(yearB) ||
            monthOrder.indexOf(monthA.toLowerCase()) - monthOrder.indexOf(monthB.toLowerCase())
        );
    });

    return result;
  }, [data, selectedYear, isLoading]);


  const [modalOpen, setmodalOpen] = useState(false);
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

const sendNotification = async (data) => {

    if(data.first_condition === 'all') {
        var usersNotif = users.filter(user => user.fcm_token);
    } else {
        var usersNotif = users.filter(user => user[data.first_condition] === data.second_condition && user.fcm_token);
    }
    // recuperer les fcm_token des utilisateurs
    const tokens = usersNotif.map(user => user.fcm_token).join(',');

    createNotification(tokens, data.title, data.message);
    setmodalOpen(false);

};




    if (isLoading) {
        return (
          <div className="flex justify-center items-center h-screen">
            <Spin size="large" />
            <p>Chargement des données ...</p>
          </div>
        );
      } 


  return (

    <Layout>
    <div>
        <h1 className='text-2xl font-bold'>Les utilisateurs</h1>

       
        <div class="grid grid-cols-4 gap-4 py-6 mobile:grid-cols-1">
            <div>
                <Card title='Profils complet' bordered={false}>
                    <Statistic
                    title=""
                    value={data && data.filter(user => user.isComplete).length * 100 / data.length}
                    precision={0}
                    suffix={'% '}
                    />
                </Card>
            </div>
            <div>
                <Card title='Titulaires' bordered={false}>
                    <Statistic
                    title=""
                    value={data && data.filter(user => user.poste === 'Pharmacien titulaire').length}
                    precision={0}
                    suffix={'sur ' + data.length}
                    />
                </Card>
            </div>
            <div>
                <Card title='Inscriptions ce mois - ci' bordered={false}>
                    <Statistic
                    title=""
                    value={data && data.filter(user => new Date(user.created_at).getMonth() === new Date().getMonth()).length}
                    precision={0}
                    prefix={'+'}
                    />
                </Card>
            </div>
        </div>
        <div class="py-6">
            <Modal open={modalOpen} footer={null} onCancel={() => setmodalOpen(false)} onClose={() => setmodalOpen(false)}>
                <h2 className='text-xl font-bold py-2'>Envoyer une notification aux utilisateurs</h2>
                <Alert className='my-4' message='Seuls les utilisateurs ayant accepté les notifications les recevront' type='info' showIcon />
                <Form onFinish={(data) => sendNotification(data)}>
                    <Form.Item name="first_condition">
                    <Select placeholder="Sélectionner une valeur" onChange={(e) => setActiveCondition(e)}>
                        {selectCondition.map((item) => (
                        <Select.Option key={item.value} value={item.value} active={item.active ? true : false} >
                            {item.label}
                        </Select.Option>
                        ))}
                    </Select>
                    </Form.Item>
                    {selectCondition.find(el => el.active === true) && selectCondition.find(el => el.active === true).items.length > 0 &&
                    <Form.Item name={'second_condition'}>
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
                        name="title"
                        rules={[{ required: true, message: 'Entrez un titre pour la notification' }]}
                    >
                        <Input placeholder="Titre de la notification" />
                    </Form.Item>
                    <Form.Item
                        name="message"
                        rules={[{ required: true, message: 'Entrez un texte pour le corps de la notification' }]}
                    >
                        <Input placeholder="Texte de la notification" />
                    </Form.Item>
                    <Form.Item>
                    <Button type="primary" htmlType="submit" block>
                        Envoyer
                    </Button>
                    </Form.Item>
                </Form>            
            </Modal>
            <Button onClick={() => setmodalOpen(true)} type='primary' text='Envoyer une notification'>
                Envoyer une notification
            </Button>
        </div>
        <div>
            <Table
            scroll={{ x: 768 }}
             columns={columns} 
             dataSource={users
                .sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
                .reverse()
                .map((user, index) => ({
                key: index,
                name: user.name,
                email: user.email,
                poste: user.poste,
                created_at: new Intl.DateTimeFormat('fr-FR', {day: '2-digit',month: '2-digit', year: 'numeric'}).format(new Date(user.created_at)),
                isComplete: user.isComplete,
                photoUrl: user.photoUrl,
              }))} />
        </div>
        <div>
            <h2 className='text-xl font-bold'>Statistiques</h2>
            <div class="grid grid-cols-2 gap-4 mobile:grid-cols-1 py-6">
                <div>
                    <Card title={`Inscriptions sur l'année ${selectedYear}`}>
                    <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                        {Array.from({ length: 5 }, (_, index) => {
                            const year = new Date().getFullYear() + index;
                            return <Select.Option key={year} value={year}>{year}</Select.Option>
                        })}
                    </Select>
                    <Line {...{
                        data: userStats,
                        xField: 'période',
                        yField: 'inscriptions',
                        label: {
                        visible: true,
                        },
                        point: {
                        size: 5,
                        shape: 'circle',
                        },
                    }} />
                    </Card>
                </div>
                <div>
                    <Card title={`Utilisateurs actifs sur ${selectedYear}`}>
                    <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                        {Array.from({ length: 5 }, (_, index) => {
                            const year = new Date().getFullYear() + index;
                            return <Select.Option key={year} value={year}>{year}</Select.Option>
                        })}
                    </Select>
                    <Line {...{
                        data: userActivity,
                        xField: 'période',
                        yField: 'connexions',
                        label: {
                        visible: true,
                        // position: 'middle',
                        },
                        point: {
                        size: 5,
                        shape: 'circle',
                        },
                    }} />
                    </Card>
                </div>
            </div>
        </div>
    </div>
    </Layout>
  )
}

export default Users