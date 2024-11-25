import React, { useMemo, useState } from 'react'
import Layout from '../Components/Layout'
import { loadPharmablabla, loadPharmacies } from '../common-functions';
import { useQuery } from 'react-query';
import { Card, Select, Spin, Statistic, Table } from 'antd';
import { Bar, Column, Line, OrganizationChart } from '@ant-design/charts';

const Pharmablabla = () => {

    const {isLoading, error, data} = useQuery('pharmablabla', () => loadPharmablabla());
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear()); // Année sélectionnée (par défaut, l'année actuelle)

    const columns = [
        {
            title: 'Utilisateur',
            dataIndex: 'user',
            key: 'user',
        },
        {
            title: 'Post',
            dataIndex: 'post_content',
            key: 'post_content',
        },
        {
            title: 'Nombre de vues',
            dataIndex: 'views',
            key: 'views',
        },
        {
            title: 'Réseau',
            dataIndex: 'network',
            key: 'network',
        }
    ];

    const monthOrder = [
        'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
        'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
      ];


    const userStats = useMemo(() => {
        if (!data) return [];
        const filteredUsers = data.posts.filter((user) => {
          const date = new Date(user.date_created);
          return date.getFullYear() === selectedYear;
        });
    
        const reduc = filteredUsers.reduce((acc, user) => {
          const date = new Date(user.date_created);
          const month = new Intl.DateTimeFormat('fr-FR', { month: 'long' }).format(date);
          const year = date.getFullYear();
          const key = `${month} ${year}`;
          acc[key] = acc[key] || 0;
          acc[key]++;
          return acc;
        }, {});
    
        const result = Object.keys(reduc).map((key) => ({
          période: key,
          post: reduc[key],
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

    const statPharmablablaopen = useMemo(() => {
        if (!data) return [];
        const filteredUsers = data.statistics.open_pharmablabla.filter((user) => {
            const dateString = user.created_at; // Supposons que user.created_at soit au format "dd/mm/yyyy"
            const [day, month, year] = dateString.split('/').map(Number); // Extraire les parties jour, mois et année
            const date = new Date(year, month - 1, day); // Créer un nouvel objet Date (les mois commencent à 0 en JavaScript)
            
          return date.getFullYear() === selectedYear;
        });
    
        const reduc = filteredUsers.reduce((acc, user) => {
            const dateString = user.created_at; // Supposons que user.created_at soit au format "dd/mm/yyyy"
            const [day, monthData, yearData] = dateString.split('/').map(Number); // Extraire les parties jour, mois et année
            const date = new Date(yearData, monthData - 1, day); // Créer un nouvel objet Date (les mois commencent à 0 en JavaScript)
            
          const month = new Intl.DateTimeFormat('fr-FR', { month: 'long' }).format(date);
          const year = date.getFullYear();
          const key = `${month} ${year}`;
          acc[key] = acc[key] || 0;
          acc[key]++;
          return acc;
        }, {});
    
        const result = Object.keys(reduc).map((key) => ({
          période: key,
          ouverture: reduc[key],
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

    if (isLoading) {
        return (
            <div className="flex justify-center items-center h-screen">
                <Spin size="large" />
            </div>
        );
    } 

  return (
    <Layout>
        <h1 className='text-2xl font-bold'>Les pharmacies</h1>
        <div class="grid grid-cols-4 mobile:grid-cols-1 py-6 gap-4">
            <div>
                <Card title='Nombre de posts' bordered={false}>
                    <Statistic
                    title=""
                    value={data.posts.length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title='Post public' bordered={false}>
                    <Statistic
                    title=""
                    value={data.posts.filter(pharmacie => pharmacie.network === "Tout Pharmabox").length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title='Post privés' bordered={false}>
                    <Statistic
                    title=""
                    value={data.posts.filter(pharmacie => pharmacie.network === "Mon réseau").length}
                    precision={0}
                    />
                </Card>
            </div>
        </div>
        <div>
            <Table
             columns={columns} 
             dataSource={data.posts
                .reverse()
                .map((pharmacie, index) => ({
                key: index,
                user: pharmacie.user,
                post_content: pharmacie.post_content,
                views: pharmacie.views,
                network: pharmacie.network
              }))} />
        </div>
        <div>
            <h2 className='text-xl font-bold'>Statistiques</h2>
            <div class="grid grid-cols-2 gap-4 mobile:grid-cols-1 py-6">
                <div>
                    <Card title={`Nombre de posts sur ${selectedYear}`}>
                    <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                        {Array.from({ length: 5 }, (_, index) => {
                            const year = new Date().getFullYear() + index;
                            return <Select.Option key={year} value={year}>{year}</Select.Option>
                        })}
                    </Select>
                    <Line {...{
                        data: userStats,
                        xField: 'période',
                        yField: 'post',
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
                    <Card title={`Ouverture du Pharmablabla sur ${selectedYear}`}>
                    <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                        {Array.from({ length: 5 }, (_, index) => {
                            const year = new Date().getFullYear() + index;
                            return <Select.Option key={year} value={year}>{year}</Select.Option>
                        })}
                    </Select>
                    <Line {...{
                        data: statPharmablablaopen,
                        xField: 'période',
                        yField: 'ouverture',
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
    </Layout>
  )
}

export default Pharmablabla