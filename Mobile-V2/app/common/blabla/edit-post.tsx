import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Form } from '@/components/Form';
import { Input } from '@/components/Input';
import { InputRadio } from '@/components/InputRadio';
import { ButtonSubmit } from '@/components/ButtonSubmit';
import { THEMES_BLABLA } from '@/common/constants/THEMES_BLABLA';
import { LinearGradient } from 'expo-linear-gradient';


export default function editPost() {

  return (
    <AuthLayout>
        <View className='p-12'>
            <Text className="font-bold text-3xl">Ajouter / modifier un post</Text>
            <View className='p-8 bg-white rounded-lg my-12'>
                <Form onSubmit={(values) => console.log(values)} initialValues={{
                    network: 'Tout Pharmabox',
                }}>
                    <Text className='text-2xl font-bold'>Lancez un sujet...</Text>
                    <Input name='content' placeholder='Ecrivez votre message ici' type='textarea' label=''></Input>

                    <View className="flex flex-row gap-3">
                        <View className='w-1/3 '>
                            <Text className='text-2xl font-bold'></Text>
                            {/* RAdio */}
                            <InputRadio name='theme' options={
                                THEMES_BLABLA.map((theme) => ({ label: theme, value: theme }))
                            } label='Thème de la publication' />
                        </View>
                        <View className='w-1/3'>
                            {/* RAdio */}
                            <InputRadio name='network' options={
                                [{ label: 'Mon réseau', value: 'Mon réseau' }, { label: 'Tout Pharmabox', value: 'Tout Pharmabox' }]
                            } label='Publier pour' />
                        </View>
                    </View>
                    <View className=''>
                    <LinearGradient
                        colors={["#42D2FF", "#7CEDAC"]}
                        start={{ x: 0.0, y: 1.0 }}
                        end={{ x: 1.0, y: 1.0 }}
                        className='rounded-lg p-1'
                    >
                        <ButtonSubmit classNameProps='py-3 text-center font-semibold text-white text-xl' text='Publier' />
                    </LinearGradient>
                    </View>
                </Form>
            </View>
        </View>
    </AuthLayout>
  );
};
