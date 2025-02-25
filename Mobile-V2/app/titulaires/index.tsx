import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';


export default function index() {

  return (
    <AuthLayout>
        <View style={styles.container}>
            <Text>Bonjour, dès aujourd'hui</Text>
            <Text>Prenez le contrôle de votre réseau</Text>
        </View>
    </AuthLayout>
  );
};
