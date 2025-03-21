import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity, TextInput, KeyboardAvoidingView, Platform, ScrollView, Dimensions } from 'react-native';
import {styles} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { LikeButton } from '@/components/LikeButton';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useLocalSearchParams } from 'expo-router';
import { formatDateFirebase } from '@/common/formatters';
import { Input } from '@/components/Input';
import { LinearGradient } from 'expo-linear-gradient';


export default function Detail() {
    const {item} = useLocalSearchParams();
    const detail = JSON.parse(item);
    const [commentText, setCommentText] = useState('');
    const [filteredComments, setFilteredComments] = useState([]);
    
    // Obtenir la largeur de l'écran
    const screenWidth = Dimensions.get('window').width;
    
    // Filtrer les commentaires qui ont un utilisateur associé
    useEffect(() => {
        if (detail.commentsData && detail.commentsData.length > 0) {
            const commentsWithUser = detail.commentsData.filter(comment => comment.user);
            setFilteredComments(commentsWithUser);
        } else {
            setFilteredComments([]);
        }
    }, [detail.commentsData]);
    
    const handleSendComment = () => {
        // Ici, vous pourriez implémenter la logique pour envoyer le commentaire
        if (commentText.trim()) {
            console.log('Envoi du commentaire:', commentText);
            // Réinitialiser le champ après envoi
            setCommentText('');
        }
    };

    return (
        <AuthLayout>
            <View style={{ flex: 1, position: 'relative' }}>
                {/* Contenu scrollable */}
                <ScrollView 
                    style={{ flex: 1 }}
                    contentContainerStyle={{ paddingBottom: 100 }} // Augmenté pour plus d'espace pour la barre de commentaire
                >
                    {/* Détails du post */}
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
                    
                    {/* Liste des commentaires - Maintenant filtrée pour n'afficher que ceux avec 'user' */}
                    <View className="px-6">
                        <Text className="text-xl font-semibold my-4">
                            Liste des commentaires
                        </Text>
                        {filteredComments.length > 0 ? (
                            filteredComments.map((comment, index) => comment.user && (
                                <View className='bg-white py-6 px-6 mt-2 rounded-lg' key={index}>
                                    <View className='flex flex-row'>
                                        <View>
                                            <Image source={ comment.user?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                                        </View>
                                        <View className='ml-2'>
                                            <Text className='text-xl font-semibold font-poppins'>{comment.user?.nom +' '+ comment.user?.prenom}</Text>
                                            <Text className='text-md text-grey_100'>{comment.user?.poste}</Text>
                                        </View>
                                    </View>
                                    <View className='py-4'>
                                        <Text>{comment.message}</Text>
                                    </View>
                                </View>
                            ))
                        ) : (
                            <View className='bg-white py-6 px-6 mt-2 items-center rounded-lg'>
                                <Text className='text-grey_100'>Aucun commentaire avec info utilisateur</Text>
                                <Text className='text-grey_100 mt-2'>Soyez le premier à commenter !</Text>
                            </View>
                        )}
                        
                        {/* Afficher le nombre total de commentaires si différent */}
                        {detail.commentsData && detail.commentsData.length > filteredComments.length && (
                            <View className='bg-white py-3 px-6 mt-4 rounded-lg'>
                                <Text className='text-grey_100 text-center'>
                                    {detail.commentsData.length - filteredComments.length} commentaire(s) sans info utilisateur masqué(s)
                                </Text>
                            </View>
                        )}
                    </View>
                </ScrollView>
                
                {/* Barre fixe de commentaire en bas avec KeyboardAvoidingView - maintenant avec largeur complète */}
                <KeyboardAvoidingView 
                    behavior={Platform.OS === "ios" ? "padding" : "height"}
                    style={{ 
                        position: 'absolute', 
                        bottom: 0, 
                        left: 0, 
                        right: 0, 
                        width: '100%'
                    }}
                >
                    <View className='bg-white absolute z-10 bottom-0 py-4 px-4 shadow-lg flex flex-row items-center gap-2 border-t border-grey_110'
                         style={{ width: screenWidth }}>
                        <View style={{ flex: 1 }}>
                            <TextInput
                                className='p-4 bg-green_110 rounded-lg'
                                placeholder='Ajouter un commentaire...'
                                placeholderTextColor="#9CA3AF"
                                value={commentText}
                                onChangeText={setCommentText}
                                multiline
                                style={{ minHeight: 50 }}
                            />
                        </View>
                        <TouchableOpacity onPress={handleSendComment}>
                            <LinearGradient
                                colors={["#42D2FF", "#7CEDAC"]}
                                start={{ x: 0.0, y: 1.0 }}
                                end={{ x: 1.0, y: 1.0 }}
                                className='rounded-full p-3'
                            >
                                <MaterialIcons name='send' size={24} color="white" />
                            </LinearGradient>
                        </TouchableOpacity>
                    </View>
                </KeyboardAvoidingView>
            </View>
        </AuthLayout>
    );
};
