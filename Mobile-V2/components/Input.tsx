import React, { useState } from 'react';
import { View, Text, TextInput } from 'react-native';
import { useForm } from './Form';

interface InputProps {
  name: string;
  label?: string;
  type?: 'text' | 'password' | 'textarea';
  placeholder?: string;
  keyboardType?: 'default' | 'number-pad' | 'decimal-pad' | 'numeric' | 'email-address' | 'phone-pad';
  formatter?: (text: string) => string;
  verifyer?: (text: string) => boolean;
  errorMessage?: string;
  searcher?: (text: string) => void;
  value?: string;
  onChangeText?: (text: string) => void;
}

export const Input = ({ 
  name, 
  label, 
  type, 
  placeholder, 
  keyboardType, 
  formatter, 
  verifyer, 
  errorMessage, 
  searcher,
  value: externalValue,
  onChangeText: externalOnChangeText
}: InputProps) => {
  const formContext = useForm();
  const [isFocused, setIsFocused] = useState(false);
  
  // Si le composant est utilisé de manière autonome (sans Form)
  const isStandalone = !formContext || externalValue !== undefined;
  
  // Valeurs et fonctions qui dépendent du contexte
  const values = isStandalone ? { [name]: externalValue } : formContext.values;
  const errors = isStandalone ? {} : formContext.errors;
  const setFieldValue = isStandalone 
    ? (fieldName: string, value: string) => externalOnChangeText && externalOnChangeText(value) 
    : formContext.setFieldValue;
  const setFieldError = isStandalone ? () => {} : formContext.setFieldError;

  const onTextChange = (text: string) => {
    const formattedText = formatter ? formatter(text) : text;
    setFieldValue(name, formattedText);
    
    if (searcher) {
      searcher(formattedText);
    }
  };

  const onBlurInput = () => {
    if (verifyer && !verifyer(values[name])) {
      setFieldError(name, errorMessage || 'Champ invalide');
    } else {
      setFieldError(name, '');
    }
  };

  return (
    <View className="mb-4 mt-2">
      {label && (
        <Text className="mb-1 font-semibold text-gray-800">{label}</Text>
      )}
      <TextInput
        secureTextEntry={type === 'password'}
        keyboardType={keyboardType || 'default'}
        placeholderTextColor="#9CA3AF" // gray-400
        multiline={type === 'textarea'}
        numberOfLines={type === 'textarea' ? 4 : 1}
        placeholder={placeholder}
        className={`
          p-4
          bg-white 
          border
          text-gray-900
          ${type === 'textarea' ? 'h-24 text-top' : ''}
          ${isFocused ? 'border-blue-600' : 'border-grey_110'}
          ${errors[name] ? 'border-red-500' : ''}
        `}
        value={values[name] || ''}
        onChangeText={onTextChange}
        onFocus={() => setIsFocused(true)}
        onBlur={() => {
          onBlurInput();
          setIsFocused(false);
        }}
      />
      {errors[name] ? (
        <Text className="text-red-500 text-xs mt-1">{errors[name]}</Text>
      ) : null}
    </View>
  );
};