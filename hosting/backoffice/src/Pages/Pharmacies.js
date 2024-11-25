import React, { useMemo, useState } from 'react'
import Layout from '../Components/Layout'
import { loadPharmacies } from '../common-functions';
import { useQuery } from 'react-query';
import { Card, Select, Spin, Statistic, Table } from 'antd';
import { Bar, Column, Line, OrganizationChart } from '@ant-design/charts';

const Pharmacies = () => {

    const {isLoading, error, data} = useQuery('pharmacies', () => loadPharmacies());
    
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

      const pharmacieStat = useMemo(() => {
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
                <Card title='Pharmacies inscrites' bordered={false}>
                    <Statistic
                    title=""
                    value={data.length}
                    precision={0}
                    />
                </Card>
            </div>
            <div>
                <Card title='Ce mois-ci' bordered={false}>
                    <Statistic
                    title=""
                    value={data.filter((pharmacie) => {
                        const createdAt = new Date(pharmacie.created_at);
                        return createdAt.getMonth() === new Date().getMonth() && createdAt.getFullYear() === new Date().getFullYear();
                      }).length}
                    precision={0}
                    />
                </Card>
            </div>
        </div>
        <div>
            <Table
             columns={columns} 
             dataSource={data
                .reverse()
                .map((pharmacie, index) => ({
                key: index,
                name: pharmacie.name,
                titulaire: pharmacie.titulaire,
                groupement: pharmacie.groupement,
                location: pharmacie.location,
              }))} />
        </div>
        <div>
            <h2 className='text-xl font-bold'>Statistiques</h2>
            <div class="grid grid-cols-2 py-4 gap-4">
                <div>
                    <Card title="Top 5 des groupement les plus populaires" bordered={false} >
                    <Bar
                        {...{
                            data: Object.entries(
                            data.reduce((acc, pharmacie) => {
                                // Regroupe les données par groupement et compte les occurrences
                                const groupement = pharmacie.groupement;
                                acc[groupement] = (acc[groupement] || 0) + 1;
                                return acc;
                            }, {})
                            )
                            .map(([groupement, count]) => ({ groupement, count })) // Transforme en tableau
                            .sort((a, b) => b.count - a.count) // Trie par ordre décroissant
                            .slice(0, 5), // Limite au top 5
                            xField: 'groupement',
                            yField: 'count',
                            seriesField: 'groupement',
                            legend: { position: 'top-left', },
                        }}
                        />
                    </Card>
                </div>
                <div>
                    <Card title="Création de pharmacies sur la période" bordered={false} >
                        <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                            {Array.from({ length: 5 }, (_, index) => {
                                const year = new Date().getFullYear() + index;
                                return <Select.Option key={year} value={year}>{year}</Select.Option>
                            })}
                        </Select>
                        <Line {...{
                            data: pharmacieStat,
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

export default Pharmacies