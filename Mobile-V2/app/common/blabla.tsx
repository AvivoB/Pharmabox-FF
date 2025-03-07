import React, { useState } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList, TouchableOpacity, Image } from 'react-native';
import {styles, widthRender} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Input } from '@/components/Input';
import { Form } from '@/components/Form';
import { usePharmablabla } from '@/hooks/usePharmablabla';
import { PostPharmablabla } from '@/components/PostPharmablabla';


export default function Blabla() {

    const { data, loading, hasMore, error, fetchData, refreshData } = usePharmablabla();
    const [network, setNetwork] = useState('Tout Pharmabox');
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
                <Input name='search' placeholder='Rechercher un post' />
                <View style={{ 
                    maxHeight: '80vh',
                    flex: 1,
                    // Appliquer les styles pour masquer la barre de défilement
                    scrollbarWidth: 'none',
                    msOverflowStyle: 'none',
                    overflow: 'auto'
                    }}>
                    <FlatList
                        data={data}
                        renderItem={(data) => <PostPharmablabla item={data.item} />}
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
                    <TouchableOpacity onPress={() => onNetworkTypeChange()} className=' px-4 py-2 bg-white flex flex-row items-center rounded-lg'>
                        <Image source={require('@/assets/images/logo-pharma-box.png')} className='rounded-lg mr-4' style={{ width: 30, height: 30 }} />
                        <Text style={[styles.description]}>{network}</Text>
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => onNetworkTypeChange()} className=' px-4 py-2 bg-white flex flex-row items-center rounded-lg'>
                        <Image source={require('@/assets/images/logo-pharma-box.png')} className='rounded-lg mr-4' style={{ width: 30, height: 30 }} />
                        <Text style={[styles.description]}>Thème</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </View>
        
    </AuthLayout>
  );
};
