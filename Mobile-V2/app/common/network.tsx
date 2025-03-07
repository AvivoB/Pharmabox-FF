import React from 'react';
import { View, Text, StyleSheet, FlatList, ActivityIndicator } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Input } from '@/components/Input';
import { useUsers } from '@/hooks/useUsers';
import { UserCard } from '@/components/UserCard';


export default function Network() {

  const [page, setPage] = React.useState('Membres');
  const { users, loading, hasMore, fetchUsers, refreshUsers, searchUsers } = useUsers();

  console.log(users);

  return (
    <AuthLayout>
        <View className='bg-white p-4'>
          <View>
            <Input name='search' placeholder='Rechercher' />
          </View>
          <View className='flex flex-row gap-6'>
              <View className='basis-1/3 flex items-center'><Text>Relations</Text></View>
              <View className='basis-1/3 flex items-center'><Text>Pharmacies</Text></View>
              <View className='basis-1/3 flex items-center'><Text>Membres</Text></View>
          </View>
        </View>
        {page === 'Pharmacies' && (
          <View>

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
    </AuthLayout>
  );
};
