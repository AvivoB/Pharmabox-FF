import React from 'react';
import { View, Text, ActivityIndicator, Image } from 'react-native';
import { useAuthState } from '@/hooks/auth/useAuth';
import { styles, widthRender } from '@/assets/style/stylesheet';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { usePathname } from 'expo-router';

const AuthLayout = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuthState();
  const pathname = usePathname().split('/')[2];

  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color="#0000ff" />
      </View>
    );
  }

  if (!user) {
    return (
      <View style={styles.container}>
        <Text style={styles.description}>Vous devez être connecté pour accéder à cette page.</Text>
      </View>
    );
  }


  const navItems = [
    { label: 'Jobs', path: 'titulaires', icon: 'campaign' },
    { label: 'Blabla', path: 'blabla', icon: 'forum' },
    { label: 'Accueil', path: 'pharmacies', icon: 'home' },
    { label: 'Réseau', path: 'network', icon: 'group' },
    { label: 'Annuaire', path: 'annuaire', icon: 'sort' },
  ]


  const accountItems = [
    { label: 'Mon compte', icon: 'person' },
    { label: 'Mes notifications', icon: 'notifications' },
    { label: 'Messagerie', icon: 'message' },
  ]

  return (
    <View className='flex flex-row'>
      <View className='basis-1/6 bg-white px-4 flex justify-between'>
        <View className='py-4 flex flex-row items-center gap-2'>
          <Image source={require('@/assets/images/logo-pharma-box.png')} className='rounded-lg' style={{ width: 50, height: 50 }} />
          <Text style={styles.h3}>Pharmabox</Text>
        </View>
        <View className=''>
          {navItems.map((item) => (
            <View className={`flex flex-row items-center gap-2 p-2 my-2 ${item.path === pathname ? 'border rounded-md border-grey_110' : ''}`} key={item.path}>
                <View><MaterialIcons name={item.icon} size={25} /></View>
                <View ><Text >{item.label}</Text></View>
            </View>
          ))}
        </View>
        <View className='py-4'>
          {accountItems.map((item) => (
            <View className='flex flex-row items-center gap-2 py-2' key={item.path}>
                <View><MaterialIcons name={item.icon} size={25} /></View>
                <View><Text >{item.label}</Text></View>
            </View>
          ))}
        </View>
      </View>
      <View className='basis-5/6'>
        {children}
      </View>
    </View>
  )
};

export default AuthLayout;