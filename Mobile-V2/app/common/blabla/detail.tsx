import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { LikeButton } from '@/components/LikeButton';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useLocalSearchParams } from 'expo-router';
import { formatDateFirebase } from '@/common/formatters';
import { Input } from '@/components/Input';


export default function Detail() {
    const {item} = useLocalSearchParams();
    const detail = JSON.parse(item);
    console.log(detail);
    return (
    <AuthLayout>
        <View className=" ">
            <View className='bg-white p-12'>
                <View className='p-6'>
                    <View className='flex flex-row justify-between pb-6'>
                        <View className='flex flex-row'>
                            <View>
                                <Image source={ detail.user?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                            </View>
                            <View className='ml-2'>
                                <Text className='text-xl font-semibold font-poppins'>{detail.user?.nom +' '+ detail.user?.prenom}</Text>
                                <Text className='text-md text-grey_100'>{detail.user?.poste}</Text>
                            </View>
                        </View>
                        <View>
                            <Text className='text-grey_100'>{formatDateFirebase(detail.date_created)}</Text>
                        </View>
                    </View>
                    <View>
                        <Text style={[styles.description]}>
                            {detail?.post_content}
                        </Text>
                    </View>
                </View>
            </View>
            <View className="px-6">
                {detail.commentsData.map((comment, index) => (
                    <View className='bg-white py-6 px-12 mt-2' key={index}>
                        <View className='flex flex-row'>
                            <View>
                                <Image source={ comment.user?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                            </View>
                            <View className='ml-2'>
                                <Text className='text-xl font-semibold font-poppins'>{comment.user?.nom +' '+ comment.user?.prenom}</Text>
                                <Text className='text-md text-grey_100'>{comment.user?.poste}</Text>
                            </View>
                        </View>
                        <View className='py-6'>
                            <Text>{comment.message}</Text>
                        </View>
                    </View>
                ))}
            </View>
            <View className='bg-white p-6 my-4 z-10 absolute bottom-0 left-0 right-0 flex flex-row items-center'>
                <View className='w-full'><Input name='comment' placeholder='Ajouter un commentaire' /></View>
                <TouchableOpacity>
                    <MaterialIcons name='send' size={25} /> 
                </TouchableOpacity>
            </View>
            
        </View>
    </AuthLayout>
  );
};
