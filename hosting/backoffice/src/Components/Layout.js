import { AlertOutlined, DiscordOutlined, MailOutlined, MedicineBoxFilled, MedicineBoxOutlined, MenuOutlined, NotificationOutlined, OrderedListOutlined, PhoneOutlined, PieChartOutlined, UserOutlined, WechatWorkOutlined } from '@ant-design/icons';
import { Menu } from 'antd'
import React, { useState } from 'react'
import { Link } from 'react-router-dom';

const Layout = ({children}) => {

    const [openMenu, setopenMenu] = useState(true);

    const items = [
        { key: '1', icon: <UserOutlined />, label: 'Utilisateurs', path: '/users' },
        { key: '2', icon: <MedicineBoxOutlined />, label: 'Pharmacies', path: '/pharmacies' },
        { key: '4', icon: <DiscordOutlined />, label: 'Pharmablabla', path: '/pharmablabla' },      
        { key: '5', icon: <WechatWorkOutlined />, label: 'Jobs', path: '/jobs' },      
        { key: '6', icon: <OrderedListOutlined />, label: 'Annuaire', path: '/annuaire' },
        { key: '7', icon: <MailOutlined />, label: 'Newsletter', path: '/newslettter' },      
        { key: '8', icon: <NotificationOutlined />, label: 'App Message', path: '/app-message' },      
      ];


  return (
    <div className='flex flex-row mobile:flex-col'>
        <div className=''>
            <div className='bg-white p-6 flex flex-row justify-between items-center'>
                <div className='flex flex-row items-center'>
                    <img className='rounded-xl w-12 mr-2' src={process.env.PUBLIC_URL + '/images/Logo SVG Pharmabox.svg'} alt=""/>
                    <h2 className='text-xl font-bold'>Backoffice</h2>
                </div>
                <div className='px-4 lg:hidden'>
                    <MenuOutlined onClick={() => setopenMenu(!openMenu)} />
                </div>
            </div>
            <div class={`flex flex-col mx-4 ${openMenu == true ? 'visible' : 'hidden'}`}>
                {items.map((item) => (
                   <Link className={`py-2 flex flex-row p-4 rounded-lg ${window.location.pathname === item.path ? 'text-blue-600 bg-blue-100': ''}`} to={item.path}> <span className='mr-4'>{item.icon}</span> {item.label} </Link>
                ))}
            </div>
        </div>
        <div className='bg-gray-100 w-full p-6'>
            <div className='bg-white min-h-screen p-12 mobile:p-4 rounded-lg'>
                {children}
            </div>
        </div>
    </div>
  )
}

export default Layout