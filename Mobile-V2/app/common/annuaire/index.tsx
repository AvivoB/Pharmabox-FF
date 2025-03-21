import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';


export default function index() {

  return (
   <AuthLayout>
        <View className='bg-white p-4'>
            <Text>Annuaire</Text>
        </View>
   </AuthLayout>
  );
};
