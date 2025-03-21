import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import { AUTH_METHODS } from '@/common/constants/AUTH_METHODS';
import { Button } from '@/components/Button';
import { Input } from '@/components/Input';
import { Form } from '@/components/Form';
import { useAuthState, signInWithEmail, signInWithGoogle, signInWithApple } from '@/hooks/auth/useAuth';
import { ButtonSubmit } from '@/components/ButtonSubmit';
import { InputRadio } from '@/components/InputRadio';


export default function index() {
    const [authMethode, setAuthMethode] = useState('');

    const loginEmail = (values) => {
        console.log(values);
        signInWithEmail(values.email, values.password);
    }

  return (
    <View className='flex-1 flex-row h-full'>
        <View className='w-1/6 h-screen bg-white px-4 border-r-2 border-grey_110 shadow-md sticky top-0'>
            <View className='py-4 flex flex-row items-center gap-2'>
                <Text className='' style={styles.h3}>Comment accéder à votre compte ?</Text>
            </View>
        <Form onSubmit={(values) => console.log(values)}>
          {authMethode == '' && AUTH_METHODS.map((method) => (
              <InputRadio key={method} name='authMethode' 
                options={[{ 
                  label: method, 
                  value: method, 
                  image: {src: require('@/assets/images/Avatar.png'), size: 40}
                }]} 
                label='' 
              />
          ))}
        </Form>
        </View>
        <View className='w-4/6 h-screen'>
            <Text className='text-3xl font-bold'>Connexion</Text>

        </View>

      <View>
        {authMethode == '' && AUTH_METHODS.map((method) => (
            <Button key={method} text={method} onPress={() => setAuthMethode(method)} />
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
