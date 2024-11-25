import { AlertOutlined, DiscordOutlined, MailOutlined, MedicineBoxFilled, MedicineBoxOutlined, NotificationOutlined, OrderedListOutlined, PhoneOutlined, PieChartOutlined, UserOutlined, WechatWorkOutlined } from '@ant-design/icons';
import { Menu } from 'antd'
import React from 'react'
import { Link } from 'react-router-dom';

const Layout = ({children}) => {

    const items = [
        { key: '1', icon: <UserOutlined />, label: 'Utilisateurs', path: '/users' },
        { key: '2', icon: <MedicineBoxOutlined />, label: 'Pharmacies', path: '/pharmacies' },
        { key: '4', icon: <DiscordOutlined />, label: 'Pharmablabla', path: '/pharmablabla' },      
        { key: '5', icon: <OrderedListOutlined />, label: 'Annuaire', path: '/annuaire' },
        { key: '6', icon: <MailOutlined />, label: 'Newsletter', path: '/newslettter' },      
        { key: '7', icon: <NotificationOutlined />, label: 'App Message', path: '/app-message' },      
      ];


  return (
    <div className='flex flex-row'>
        <div className=''>
            <div className='bg-white p-4'>
                <h2 className='text-xl font-bold'>Backoffice</h2>
            </div>
            <div class="flex flex-col mx-4 ">
                {items.map((item) => (
                   <Link className={`py-2 flex flex-row p-4 rounded-lg ${window.location.pathname === item.path ? 'text-blue-600 bg-blue-100': ''}`} to={item.path}> <span className='mr-4'>{item.icon}</span> {item.label} </Link>
                ))}
            </div>
        </div>
        <div className='bg-gray-100 w-full p-6'>
            <div className='bg-white min-h-screen p-12 rounded-lg'>
                {children}
            </div>
        </div>
    </div>
  )
}

export default Layout