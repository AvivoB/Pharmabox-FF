import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';


export default function index() {


    const navItems = [
        { label: 'Ma pharmacie', icon: 'local-pharmacy', path: 'pharmacies' },
        { label: 'Profil', icon: 'contacts', path: 'directory' },
        { label: 'Mes amis', icon: 'group', path: 'friends' },
    ];

  return (
    <AuthLayout>
        <View className="flex flex-row p-4">
            <View className='w-2/3'></View>
            <View className='w-1/3'>
                <View className='border border-grey_110 bg-white p-4 rounded-lg shadow-sm'>
                    {navItems.map((item, index) => (
                        <View key={index} className="flex flex-row items-center gap-2">
                            <MaterialIcons name={item.icon} size={25} />
                            <Text style={styles.description}>{item.label}</Text>
                        </View>
                    ))}
                </View>
            </View>
        </View>
    </AuthLayout>
  );
};
