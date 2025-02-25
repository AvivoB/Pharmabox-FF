import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import { AUTH_METHODS } from '@/common/constants/AUTH_METHODS';
import { Button } from '@/components/Button';
import { Input } from '@/components/Input';
import { Form } from '@/components/Form';
import { useAuthState, signInWithEmail, signInWithGoogle, signInWithApple } from '@/hooks/auth/useAuth';
import { ButtonSubmit } from '@/components/ButtonSubmit';


export default function index() {
    const [authMethode, setAuthMethode] = useState('');

    const loginEmail = (values) => {
        console.log(values);
        signInWithEmail(values.email, values.password);
    }

  return (
    <View style={styles.container}>
        <Text style={styles.description}>Connectez - vous à votre compte</Text>

      <View>
        {authMethode == '' && AUTH_METHODS.map((method) => (
            <Button key={method} text={method} styleType='btnPrimary' onPress={() => setAuthMethode(method)} />
        ))}
      </View>
      {authMethode === 'Email' && (
        <View>
            <Text>Connexion par email</Text>
            <Form onSubmit={(values) => loginEmail(values)}>
                <Input name="email" label="Email" />
                <Input name='password' type='password' label="Mot de passe" />
                <ButtonSubmit text='Connexion' />
            </Form>
        </View>
        )}
    </View>
  );
};
