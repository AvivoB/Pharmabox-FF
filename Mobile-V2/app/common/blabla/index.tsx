import React, { useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList, TouchableOpacity, Image } from 'react-native';
import {styles, widthRender} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Input } from '@/components/Input';
import { Form } from '@/components/Form';
import { usePharmablabla } from '@/hooks/usePharmablabla';
import { PostPharmablabla } from '@/components/PostPharmablabla';
import { router } from 'expo-router';
import { InputRadio } from '@/components/InputRadio';
import { THEMES_BLABLA } from '@/common/constants/THEMES_BLABLA';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { LinearGradient } from 'expo-linear-gradient';


export default function Blabla() {

    const [network, setNetwork] = useState('Tout Pharmabox');
    const { data, loading, hasMore, error, fetchData, refreshData } = usePharmablabla();
    const onNetworkTypeChange = () => {
        if(network === 'Tout Pharmabox') {
            setNetwork('Mon réseau');
        } else {
            setNetwork('Tout Pharmabox');
        }
    }



  return (
    <AuthLayout>
        <View style={styles.container}>
            <View className='flex-row gap-6'>
                <View className='basis-2/3'>
                <Form onSubmit={(values) => console.log(values)} initialValues={{ search: '' }}>
                    <Input label='' name='search' placeholder='Rechercher une publication' />
                </Form>
                <View 
                    className='max-h-screen'
                    style={{ 
                    // maxHeight: '80vh',
                    flex: 1,
                    // Appliquer les styles pour masquer la barre de défilement
                    scrollbarWidth: 'none',
                    msOverflowStyle: 'none',
                    overflow: 'auto'
                    }}>
                    <FlatList
                        data={data}
                        renderItem={(data,) => <PostPharmablabla item={data.item} />}
                        keyExtractor={(item) => item.id}
                        onEndReached={() => hasMore && fetchData()}
                        onEndReachedThreshold={0.5}
                        refreshing={loading}
                        onRefresh={refreshData}
                        ListFooterComponent={loading ? <ActivityIndicator /> : null}
                        showsVerticalScrollIndicator={false} // Masquer la barre de défilement native
                        style={{
                            flex: 1
                        }}
                        contentContainerStyle={{
                            paddingBottom: 20
                        }}
                        initialNumToRender={5}
                        maxToRenderPerBatch={10}
                        windowSize={10}
                        legacyImplementation={false}
                    />
                    </View>
                </View>
                <View className='basis-1/3 p-4'>
                    <View className='mb-4'>
                        <LinearGradient 
                            colors={["#42D2FF", "#7CEDAC"]}
                            start={{ x: 0.0, y: 1.0 }}
                            end={{ x: 1.0, y: 1.0 }}
                            className='rounded-lg p-1'
                        >
                            <TouchableOpacity onPress={() => {
                                router.push({ pathname: `/common/blabla/edit-post` });
                            }} className=' px-4 py-2  flex flex-row items-center rounded-lg '>
                                <MaterialIcons color={'white'} name={'add'} size={25} />
                                <Text style={[styles.description]} className='pl-2 text-white'>Ajouter une publication</Text>
                            </TouchableOpacity>
                        </LinearGradient>
                    </View> 
                    <View>
                        <Text className="text-base font-medium mb-1 text-gray-800">Afficher les publication de </Text>
                        <TouchableOpacity onPress={() => onNetworkTypeChange()} className=' px-4 py-2 bg-white flex flex-row items-center rounded-lg'>
                            <Image source={require('@/assets/images/logo-pharma-box.png')} className='rounded-lg mr-4' style={{ width: 30, height: 30 }} />
                            <Text style={[styles.description]}>{network}</Text>
                        </TouchableOpacity>
                    </View>
                    <View className='mt-4'>
                        <Form onSubmit={(values) => console.log(values)} initialValues={{} }>
                            <InputRadio name='theme' options={
                                THEMES_BLABLA.map((theme) => ({ label: theme, value: theme }))
                            } label='Filtrer par thèmes' />

                        </Form>
                    </View>
                    
                </View>
            </View>
        </View>
        
    </AuthLayout>
  );
};
