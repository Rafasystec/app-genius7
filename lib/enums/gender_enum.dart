enum Gender{
  OTHER,
  FEMALE,
  MALE
}

String getTextEnumGender(Gender gender){
  switch(gender){
    case Gender.OTHER :
      return 'Outro';
    break;
    case Gender.FEMALE :
      return 'Feminino';
    break;
    case Gender.MALE :
      return 'Masculino';
    break;
    default :
      return 'Outro';
    break;
  }
}

