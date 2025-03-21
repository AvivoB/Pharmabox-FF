import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList, TouchableOpacity, Image, TextInput } from 'react-native';
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
import { useAuthState } from '@/hooks/auth/useAuth';


export default function Blabla() {
    const [network, setNetwork] = useState('Tout Pharmabox');
    const [selectedTheme, setSelectedTheme] = useState('');
    const [filteredData, setFilteredData] = useState([]);
    const [searchQuery, setSearchQuery] = useState('');
    const { data, loading, hasMore, error, fetchData, refreshData } = usePharmablabla();
    const { user } = useAuthState();

    // Appliquer les filtres (thème, réseau et recherche) lorsqu'ils changent ou que les données sont mises à jour
    useEffect(() => {
        let result = [...data];
        
        // Filtre par thème
        if (selectedTheme) {
            result = result.filter(item => item.theme === selectedTheme);
        }
        
        // Filtre par réseau
        if (network === 'Mon réseau' && user) {
            // Filtrer les publications pour n'afficher que celles de l'utilisateur ou de son réseau
            result = result.filter(item => {
                // Vérifier si l'utilisateur est l'auteur ou est dans le réseau de l'auteur
                return item.userId === user.uid || user?.reseau.includes(item.userId);
            });
        }

        // Filtre par recherche (nom, prénom ou contenu)
        if (searchQuery.trim() !== '') {
            const query = searchQuery.toLowerCase().trim();
            result = result.filter(item => {
                // Recherche dans le contenu du post
                const contentMatch = item.content && item.content.toLowerCase().includes(query);
                
                // Recherche dans le nom et prénom de l'auteur
                const userFirstNameMatch = item.user?.firstName && item.user.firstName.toLowerCase().includes(query);
                const userLastNameMatch = item.user?.lastName && item.user.lastName.toLowerCase().includes(query);
                const userFullNameMatch = item.user?.firstName && item.user?.lastName && 
                    `${item.user.firstName} ${item.user.lastName}`.toLowerCase().includes(query);
                
                return contentMatch || userFirstNameMatch || userLastNameMatch || userFullNameMatch;
            });
        }
        
        setFilteredData(result);
    }, [selectedTheme, network, data, user, searchQuery]);

    const onNetworkTypeChange = () => {
        if(network === 'Tout Pharmabox') {
            setNetwork('Mon réseau');
        } else {
            setNetwork('Tout Pharmabox');
        }
    }

    // Fonction pour effacer tous les filtres
    const clearFilters = () => {
        setSelectedTheme('');
        setNetwork('Tout Pharmabox');
        setSearchQuery('');
    }

    return (
        <AuthLayout>
            <View style={styles.container}>
                <View className='flex-row gap-6'>
                    <View className='basis-2/3'>
                        {/* Remplacer le composant Form par un TextInput direct pour éviter les problèmes de contexte */}
                        <View className="mb-4 mt-2">
                            <TextInput
                                placeholder='Rechercher par nom, prénom ou contenu'
                                placeholderTextColor="#9CA3AF"
                                className="p-4 bg-white border border-grey_110 text-gray-900"
                                value={searchQuery}
                                onChangeText={(text) => setSearchQuery(text)}
                            />
                        </View>
                        
                        {(selectedTheme || network === 'Mon réseau' || searchQuery) && (
                            <View className='flex flex-row items-center justify-between my-2 bg-green_110 rounded-lg p-2'>
                                <View className='flex flex-row items-center'>
                                    <Text className='text-black_100 font-semibold'>
                                        Publications affichées : {[
                                            selectedTheme && selectedTheme,
                                            network === 'Mon réseau' && 'Mon réseau',
                                            searchQuery && `Recherche: "${searchQuery}"`
                                        ].filter(Boolean).join(', ')}
                                    </Text>
                                </View>
                                <TouchableOpacity onPress={clearFilters} className='ml-2 p-1 bg-white rounded-full'>
                                    <MaterialIcons name='close' size={16} color="#161730" />
                                </TouchableOpacity>
                            </View>
                        )}
                        
                        {/* Reste du code inchangé */}
                        <View 
                            className='max-h-screen'
                            style={{ 
                                flex: 1,
                                scrollbarWidth: 'none',
                                msOverflowStyle: 'none',
                                overflow: 'auto'
                            }}>
                            <FlatList
                                data={filteredData}
                                renderItem={(data) => <PostPharmablabla item={data.item} />}
                                keyExtractor={(item) => item.id}
                                onEndReached={() => hasMore && fetchData()}
                                onEndReachedThreshold={0.5}
                                refreshing={loading}
                                onRefresh={refreshData}
                                ListFooterComponent={loading ? <ActivityIndicator /> : null}
                                ListEmptyComponent={
                                    !loading && (
                                        <View className='p-4 bg-white my-2 rounded-lg flex items-center'>
                                            <Text>Aucune publication trouvée</Text>
                                            {filteredData.length === 0 && data.length > 0 && (
                                                <TouchableOpacity onPress={clearFilters} className='mt-2 p-2 bg-blue_110 rounded-lg'>
                                                    <Text className='text-white'>Effacer les filtres</Text>
                                                </TouchableOpacity>
                                            )}
                                        </View>
                                    )
                                }
                                showsVerticalScrollIndicator={false}
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
                    
                    {/* ...existing code... */}
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
                            <Text className="text-base font-medium mb-1 text-gray-800">Afficher les publications de</Text>
                            <View className="bg-white rounded-lg p-3">
                                <TouchableOpacity 
                                    onPress={() => setNetwork(network === 'Tout Pharmabox' ? 'Mon réseau' : 'Tout Pharmabox')}
                                    className={`py-2 px-3 my-1 rounded-lg flex-row justify-between items-center ${network === 'Tout Pharmabox' ? 'bg-blue_110' : ''}`}
                                >
                                    <View className='flex-row items-center'>
                                    {network === 'Tout Pharmabox' ? 
                                        <Image source={require('@/assets/images/logo-pharma-box.png')} className='rounded-lg mr-2' style={{ width: 24, height: 24 }} />
                                    :
                                        <MaterialIcons name="group" size={24} className='mr-2' />
                                    }
                                        <Text className={`text-gray-800`}>{network}</Text>
                                    </View>
                                    
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View className='mt-4'>
                            <Text className="text-base font-medium mb-1 text-gray-800">Filtrer par thèmes</Text>
                            <View className="bg-white rounded-lg p-3">
                                {THEMES_BLABLA.map((theme) => (
                                    <TouchableOpacity 
                                        key={theme}
                                        onPress={() => setSelectedTheme(selectedTheme === theme ? '' : theme)}
                                        className={`py-2 px-3 my-1 rounded-lg flex-row justify-between items-center ${selectedTheme === theme ? 'bg-blue_110' : ''}`}
                                    >
                                        <Text style={styles.description} className='text-black_100'>{theme}</Text>
                                        {selectedTheme === theme && (
                                            <MaterialIcons name="check" size={18} color="white" />
                                        )}
                                    </TouchableOpacity>
                                ))}
                            </View>
                        </View>
                    </View>
                </View>
            </View>
        </AuthLayout>
    );
};
