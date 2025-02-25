import React from 'react';
import { Button } from './Button';
import { useForm } from './Form';

interface ButtonSubmitProps {
  text: string;
  styleType?: 'btnPrimary' | 'btnSecondary' | 'btnSecondaryOutline';
}

export const ButtonSubmit = ({ text, styleType = 'btnPrimary' }: ButtonSubmitProps) => {
  const { isValid, handleSubmit } = useForm();

  return (
    <Button 
      onPress={handleSubmit} 
      styleType={styleType} 
      text={text} 
    />
  );
};
