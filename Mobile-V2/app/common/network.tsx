import React from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator, TouchableOpacity } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Input } from '@/components/Input';
import { useUsers } from '@/hooks/useUsers';
import { UserCard } from '@/components/UserCard';
import { LinearGradient } from 'expo-linear-gradient';
import { MapPharmacies } from '../../components/MapPharmacies';
import { useAuthState } from '@/hooks/auth/useAuth';
import { useNetwork } from '@/hooks/useNetwork';

export default function Network() {

  const [page, setPage] = React.useState('Membres');
  const { users, loading, hasMore, fetchUsers, refreshUsers, searchUsers } = useUsers();
  const {users: userNetwork, loading: loadingNetwork, error: errorNetwork} = useNetwork();

  const pages = [ 'Relations', 'Pharmacies', 'Membres' ];

  return (
    <AuthLayout>
        <View className='flex flex-row'>
          <View className='w-2/3'>
            <View className=''>
              <View>
                <Input name='search' placeholder='Rechercher' />
              </View>
            </View>
            {page === 'Pharmacies' && (
              <View>
                <MapPharmacies />
              </View>
            )}
            {page === 'Membres' && (
              <View
              className='p-4'
                style= {{
                  maxHeight: '81vh',
                  flex: 1,
                  // Appliquer les styles pour masquer la barre de défilement
                  scrollbarWidth: 'none',
                  msOverflowStyle: 'none',
                  overflow: 'auto'
                 }}
              >
                  <FlatList
                      data={users}
                      renderItem={(data) => <UserCard item={data.item} />}
                      keyExtractor={(item) => item.id}
                      onEndReached={() => hasMore && fetchUsers()}
                      onEndReachedThreshold={0.5}
                      refreshing={loading}
                      onRefresh={refreshUsers}
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
            )}
            {page === 'Relations' && (
              <View className='p-4'>
                <Text style={styles.h3}>Mon réseau</Text>
                <View className=''>
                {userNetwork.map((item, index) => (
                  <UserCard key={index} item={item} />
                ))}
                </View>
              </View>
            )}
          </View>
          <View className='w-1/3'>
          <View className=''>
            {pages.map((item, index) => (
              <View key={index} className=' rounded-lg py-2 px-2 my-2'>
                <TouchableOpacity
                  onPress={() => setPage(item)}
                  className='rounded-lg'
                >
                  {page === item ? (
                    <LinearGradient
                      colors={["#91EAE4", "#86A8E7", "#7F7FD5"]}
                      start={{ x: 0.0, y: 1.0 }}
                      end={{ x: 1.0, y: 1.0 }}
                      className='px-4 py-2'
                    >
                      <Text className='text-center text-white'>{item}</Text>
                    </LinearGradient>
                  ) : (
                    <View className='px-4 py-2 bg-white'>
                      <Text className='text-center text-black'>{item}</Text>
                    </View>
                  )}
                </TouchableOpacity>
              </View>
            ))}
          </View>
          </View>
        </View>
    </AuthLayout>
  );
};
