import React, { useMemo, useState } from 'react'
import Layout from '../Components/Layout'
import { loadAnnuaire, loadPharmacies } from '../common-functions';
import { useQuery } from 'react-query';
import { Button, Card, Select, Spin, Statistic, Table } from 'antd';
import { Bar, Column, Line, OrganizationChart } from '@ant-design/charts';
import axios from 'axios';
import { Loading3QuartersOutlined } from '@ant-design/icons';

const Annuaire = () => {

    const {isLoading, error, data} = useQuery('annuaire', () => loadAnnuaire());
    const [loadingAnnuaire, setloadingAnnuaire] = useState(false);

    const columns = [
        {
            title: 'Nom',
            dataIndex: 'name',
            key: 'name',
        },
        {
            title: 'Image',
            dataIndex: 'image',
            key: 'image',
            render: (data) => <img src={`${data}`}  />,
        },
        {
            title: 'Adresse',
            dataIndex: 'address',
            key: 'address',
        }, 
        {
            title: 'Téléphone',
            dataIndex: 'phone',
            key: 'phone',
        },
        {
            title: 'Email',
            dataIndex: 'email',
            key: 'email',
        },
        {
            title: 'Site web',
            dataIndex: 'website',
            key: 'website',
        },
        {
            title: 'Description',
            dataIndex: 'desription',
            key: 'desription',
        }
    ];

    const monthOrder = [
        'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
        'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
      ];


      const [selectedYear, setSelectedYear] = useState(new Date().getFullYear()); // Année sélectionnée (par défaut, l'année actuelle)

      const annauireStats = useMemo(() => {
        if (!data) return [];
        const filteredUsers = data.statistics.open_annuaire.filter((user) => {
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

    const updateAnnauire = async () => {
        setloadingAnnuaire(true);
        axios.post(`${process.env.REACT_APP_API_URL}/annuaire-scrapper`, {}, {
            headers: {
                Authorization: `Bearer ${localStorage.getItem('token_pharmabox')}`
            }
        }).then(response => {
            console.log(response.data);
            setloadingAnnuaire(false);
        });
    }

    if (isLoading) {
        return (
            <div className="flex justify-center items-center h-screen">
                <Spin size="large" />
            </div>
        );
    } 

  return (
    <Layout>
        <h1 className='text-2xl font-bold'>L'annuaire : {data.annuaire.length} Laboratoires</h1>
        <div class="py-6">
        <Button type={loadingAnnuaire ? 'default' : 'primary'} disabled={loadAnnuaire ? false : true} onClick={() => updateAnnauire()}>
            {loadingAnnuaire ? (
                <>
                <Spin indicator={<Loading3QuartersOutlined color='white' spin />} size="small" /> Récupération en cours depuis LaboData
                </>
            ) : (
                'Mettre à jour l\'annuaire'
            )}
            </Button>
        </div>
        <div>
            <Table
            scroll={{ x: 1500 }}
             columns={columns} 
             dataSource={data.annuaire
                .reverse()
                .map((annauire, index) => ({
                key: index,
                name: annauire.name,
                image: annauire.image,
                address: annauire.address,
                phone: annauire.phone,
                email: annauire.email,
                website: annauire.website,
                desription: annauire.desription,
              }))} />
        </div>
        <div>
            <h2 className='text-xl font-bold'>Statistiques</h2>
            <div class="grid grid-cols-1 py-4 gap-4">
                <div>
                <Card title={`Nombre de posts sur ${selectedYear}`}>
                    <Select className='w-full' defaultValue={selectedYear} onChange={setSelectedYear}>
                        {Array.from({ length: 5 }, (_, index) => {
                            const year = new Date().getFullYear() + index;
                            return <Select.Option key={year} value={year}>{year}</Select.Option>
                        })}
                    </Select>
                    <Line {...{
                        data: annauireStats,
                        xField: 'période',
                        yField: 'ouverture',
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

export default Annuaire