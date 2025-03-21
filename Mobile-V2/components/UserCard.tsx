import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import React from 'react';
import { View, Text, Image, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useAuthState } from '@/hooks/auth/useAuth';


export const UserCard = ({ item }) => {

    const {user, loading} = useAuthState();

    console.log('item', item);
    
    return (
    <View className='bg-white  m-2 rounded-lg'>
        <View className="flex flex-row justify-between">
            <View className='flex flex-row p-4'>
                <View>
                    <Image source={ item?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                </View>
                <View className='ml-2'>
                    <Text className='text-xl font-semibold font-poppins'>{item?.nom +' '+ item?.prenom}</Text>
                    <Text className='text-md'>{item?.poste}</Text>
                </View>
            </View>
            <View>
                <View className='p-2'>
                    {loading == false && item?.uid && user?.reseau?.includes(item?.uid) ?
                        <TouchableOpacity className='shadow-sm px-4 py-2 flex flex-row gap-2 rounded-lg bg-white border border-grey_110'>
                            <MaterialIcons name="delete" className='text-red_100' size={18} />
                            <Text className='text-red_100'>Retirer des relations</Text>
                        </TouchableOpacity>

                        :

                        <TouchableOpacity className='shadow-sm px-4 py-2 flex flex-row gap-2 rounded-lg bg-white border border-grey_110'>
                            <MaterialIcons name="add" className='text-blue_100' size={18} />
                            <Text className='text-blue_100'>Ajouter</Text>
                        </TouchableOpacity>
                    }
                </View>
            </View>
        </View>
        { item?.city && item?.country &&
            <View className="flex flex-row items-center px-4 py-2">
                <MaterialIcons name='location-pin' size={24} className='text-grey_100' ></MaterialIcons>
                <Text className='pl-2'>{item?.city}, {item?.country}</Text>
            </View>
        }
        <View className='p-4 bg-green_110 rounded-b-lg flex flex-row gap-3 items-end'> 
            { item?.afficher_tel &&
            <TouchableOpacity className='rounded-full overflow-hidden'>
                <LinearGradient
                    colors={['#4CAF50', '#81C784']}
                    className='w-full h-full justify-center items-center'
                >
                    <View className="p-3 bg-white">
                        <MaterialIcons name='phone'  size={18} className='text-blue_100' />
                    </View>
                </LinearGradient>
            </TouchableOpacity>
            }
            {item?.aficher_email =="true" &&
            <TouchableOpacity className='rounded-full overflow-hidden'>
                <LinearGradient
                    colors={['#4CAF50', '#81C784']}
                    className='w-full h-full justify-center items-center'
                >
                    <View className="p-3 bg-white">
                        <MaterialIcons name='mail'  size={18} className='text-blue_100' />
                    </View>
                </LinearGradient>
            </TouchableOpacity>
            }
            <TouchableOpacity className='rounded-full overflow-hidden'>
                <LinearGradient
                    colors={['#4CAF50', '#81C784']}
                    className='w-full h-full justify-center items-center'
                >
                    <View className="p-3 rounded-full bg-white">
                        <MaterialIcons name='message'  size={18} className='text-blue_100' />
                    </View>
                </LinearGradient>
            </TouchableOpacity>
        </View>
    </View>
  );
};
