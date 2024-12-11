import React, { useMemo, useState } from 'react'
import Layout from '../Components/Layout'
import { loadJobs } from '../common-functions';
import { useQuery } from 'react-query';
import { Card, Select, Spin, Statistic, Table } from 'antd';
import { Bar, Column, Line, OrganizationChart } from '@ant-design/charts';

const Jobs = () => {

    const {isLoading, error, data} = useQuery('Jobs', () => loadJobs());
    
    const columns = [
        {
            title: 'Nom',
            dataIndex: 'name',
            key: 'name',
        },
        {
            title: 'Titulaire',
            dataIndex: 'titulaire',
            key: 'titulaire',
        },
        {
            title: 'Groupement',
            dataIndex: 'groupement',
            key: 'groupement',
        }, 
        {
            title: 'Localisation',
            dataIndex: 'location',
            key: 'location',
        }
    ];


    const monthOrder = [
        'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
        'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
      ];
      const [selectedYear, setSelectedYear] = useState(new Date().getFullYear()); // Année sélectionnée (par défaut, l'année actuelle)

      const Jobstat = useMemo(() => {
        if (!data) return [];
        const filteredUsers = data.offres.filter((user) => {
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

        console.log(reduc);
    
        const result = Object.keys(reduc).map((key) => ({
          période: key,
          creation: reduc[key],
        }));


    
        result.sort((a, b) => {
            const [monthA, yearA] = a.période.split(' ');
            const [monthB, yearB] = b.période.split(' ');
            return (
                parseInt(yearA) - parseInt(yearB) ||
                monthOrder.indexOf(monthA.toLowerCase()) - monthOrder.indexOf(monthB.toLowerCase())
            );
        });
    
        console.log(result);
        return result;
      }, [data, selectedYear, isLoading]);

      const RechercheStat = useMemo(() => {
        if (!data) return [];
        const filteredUsers = data.recherches.filter((user) => {
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

        console.log(reduc);
    
        const result = Object.keys(reduc).map((key) => ({
          période: key,
          creation: reduc[key],
        }));


    
        result.sort((a, b) => {
            const [monthA, yearA] = a.période.split(' ');
            const [monthB, yearB] = b.période.split(' ');
            return (
                parseInt(yearA) - parseInt(yearB) ||
                monthOrder.indexOf(monthA.toLowerCase()) - monthOrder.indexOf(monthB.toLowerCase())
            );
        });
    
        console.log(result);
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
        <h1 className='text-2xl font-bold'>Les Jobs</h1>
        <div class="grid grid-cols-4 mobile:grid-cols-1 py-6 gap-4">
            <div>
                <Card title="Nombre d'offres actives" bordered={false}>
                    <Statistic
                    title=""
                    value={data.offres.length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title='Offres créées ce mois-ci' bordered={false}>
                    <Statistic
                    title=""
                    value={data.offres.filter((pharmacie) => {
                        const createdAt = new Date(pharmacie.created_at);
                        return createdAt.getMonth() === new Date().getMonth() && createdAt.getFullYear() === new Date().getFullYear();
                      }).length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title="Nombre de recherches actives" bordered={false}>
                    <Statistic
                    title=""
                    value={data.recherches.length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title='Recherches créées ce mois-ci' bordered={false}>
                    <Statistic
                    title=""
                    value={data.recherches.filter((pharmacie) => {
                        const createdAt = new Date(pharmacie.created_at);
                        return createdAt.getMonth() === new Date().getMonth() && createdAt.getFullYear() === new Date().getFullYear();
                      }).length}
                    precision={0}
                    />
                </Card>
            </div>
        </div>
        <div>
            {/* <Table
            scroll={{ x: 768 }}
             columns={columns} 
             dataSource={data
                .reverse()
                .map((pharmacie, index) => ({
                key: index,
                name: pharmacie.name,
                titulaire: pharmacie.titulaire,
                groupement: pharmacie.groupement,
                location: pharmacie.location,
              }))} /> */}
        </div>
        <div>
            <h2 className='text-xl font-bold'>Statistiques</h2>
            <div class="grid grid-cols-2 mobile:grid-cols-1 py-4 gap-4">
                <div>
                    <Card title="Création d'offres sur la période" bordered={false} >
                        <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                            {Array.from({ length: 5 }, (_, index) => {
                                const year = new Date().getFullYear() + index;
                                return <Select.Option key={year} value={year}>{year}</Select.Option>
                            })}
                        </Select>
                        <Line {...{
                            data: Jobstat,
                            xField: 'période',
                            yField: 'creation',
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
                    <Card title="Création de recherches sur la période" bordered={false} >
                        <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                            {Array.from({ length: 5 }, (_, index) => {
                                const year = new Date().getFullYear() + index;
                                return <Select.Option key={year} value={year}>{year}</Select.Option>
                            })}
                        </Select>
                        <Line {...{
                            data: RechercheStat,
                            xField: 'période',
                            yField: 'creation',
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
            </div>
        </div>
    </Layout>
  )
}

export default Jobs