import React from 'react';
import { View, Text, ActivityIndicator, Image, ScrollView } from 'react-native';
import { useAuthState } from '@/hooks/auth/useAuth';
import { styles } from '@/assets/style/stylesheet';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { usePathname } from 'expo-router';
import { Link } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import MaskedView from '@react-native-masked-view/masked-view';

const AuthLayout = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuthState();
  const pathname = usePathname().split('/')[2];

  if (loading) {
    return (
      <View className="flex-1 items-center justify-center">
        <ActivityIndicator size="large" color="#0000ff" />
      </View>
    );
  }

  if (!user) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-lg text-center">Vous devez être connecté pour accéder à cette page.</Text>
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
    <View className="flex-1 flex-row h-full">
      {/* Menu fixe qui prend toute la hauteur */}
      <View className="w-1/6 h-screen bg-white px-4 flex justify-between border-r-2 border-grey_110 shadow-md sticky top-0">
        <View className="py-4 flex flex-row items-center gap-2">
          <Image source={require('@/assets/images/logo-pharma-box.png')} className="rounded-full" style={{ width: 40, height: 40 }} />
          <Text style={styles.h3}>Pharmabox</Text>
        </View>
        <View className="flex-1">
          {navItems.map((item, index) => (
            <Link href={`/common/${item.path}`} key={index} asChild>
              <View className={`flex flex-row justify-between items-center gap-2 p-2 my-2 ${item.path === pathname ? 'border rounded-md border-grey_110' : ''}`}>
                <View className='flex flex-row items-center gap-2'>
                  <MaterialIcons name={item.icon} size={25} />
                  <Text style={styles.description}>{item.label}</Text>
                </View>
                <View>
                  {item.path === pathname &&
                    <LinearGradient
                      colors={["#42D2FF", "#7CEDAC"]}
                      start={{ x: 0.0, y: 1.0 }}
                      end={{ x: 1.0, y: 1.0 }}
                      className='w-2 h-2 rounded-full'
                    >
                    </LinearGradient>
                  }
                </View>
              </View>
            </Link>
          ))}
        </View>
        <View className="py-4 border-t border-grey_110">
          {accountItems.map((item, index) => (
            <View className="flex flex-row items-center gap-2 py-2" key={index}>
              <MaterialIcons name={item.icon} size={25} />
              <Text style={styles.description}>{item.label}</Text>
            </View>
          ))}
        </View>
      </View>
      
      {/* Contenu défilable */}
      <ScrollView className="w-5/6 flex-1">
        <View className="flex-1 pb-10">
          {children}
        </View>
      </ScrollView>
    </View>
  );
};

export default AuthLayout;