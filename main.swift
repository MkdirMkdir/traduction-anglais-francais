/**
 * @file main.swift
 * @brief Allow the creation of dynamic Dictionnary between 2 languages.
 *
 * Create Dictionnaries, with any words and any traduction wanted using methods and functions !
 * Display your dictionnaries using made-in method 'show_dictionnary'.
 * 
 * - Author : Mattéo MARTINI
 * - Date : 23/10/2026
 * - Version : 1.0.0
 * - Liscense : MIT License (https://opensource.org)
 *
 * Copyright © 2026 Mattéo MARTINI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in this software without restriction...
 *
**/

// A dictionnary of a specific language
class Dictionnary {

    // CLASS INIT
    // This Class contain all Translated_Words which begin with a specific letter.
    // Used to speedup search.
    ////Why a class? Because it will be passed as a pointer instead of itself, meaning I don't have to copy past every times///
    class Words_Letter {
        let LETTER : Character
        // All of the words
        var words : [Translated_Word]

        init(_ l : Character, _ w : [Translated_Word]){LETTER = l; words = w}
    }

    // This class represent a single word, containing another
    // Translated_Word wich is his traduction.
    class Translated_Word{
        // the word itself
        var word : String
        // Translation
        var translation : Translated_Word? = nil

        init(_ word : String, _ translation : Translated_Word? = nil){self.word = word;self.translation = translation}
    }
    
    // DICTIONNARY, VARIABLES AND FUNC INIT
    let LANGUAGE : String
    var Letters : [Words_Letter] = []

    init(_ language : String){
        LANGUAGE = language
        self.initialize_letters()
    }

    // INITIALIZE DICTIONNARY
    // Intialize the dictionnary which is passed as a pointer.
    // For now its only support Alphabetic letters.
    func initialize_letters() -> Void{
        let LETTERS : [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        for char in LETTERS{
            self.Letters.append(Words_Letter(char,[]))
        }
    }

    // USE DICTIONNARY
    // True if the word is in the dict, false otherwise (including if the word isn't correct in the first place)
    func is_in_dictionnary(_ w : String) -> Bool{
        if !is_word_correct(w){return false}
        let char : Character = w.first!

        for l in self.Letters{

            // Get the letter category
            if l.LETTER == char{

                // Check if the word is in
                for word in l.words{
                    if word.word == w{
                        // We can exit the loop right now, no need to check other letters/words
                        return true
                    }
                }
            }
        }

        return false
    }

    // Get the translation of a word if it exist, otherwise return [<ERROR>]
    func get_translation(_ w : String) -> String{
        if !self.is_in_dictionnary(w){return "[NOT IN DICT]"}
        let translated_word_instance : Translated_Word? = self.get_Translated_Word(w)!.translation

        if translated_word_instance == nil{return "[WORD DOES NOT HAVE A TRANSLATION SET]"}
        return self.get_Translated_Word(w)!.translation!.word
    }

    // DYNAMIC DICTIONNARY
    // Try to add a word into the dictionnary, if its already in or if the word itself isn't valid, return false
    func add_word(_ w : String) -> Bool{ 
        //Security Check
        if !is_word_correct(w){return false}
        //Doublon Check
        if self.is_in_dictionnary(w){return false}
        
        let l : Character? = w.first
        // Security Check
        var w_l : Words_Letter? = self.get_letter_group(l!)
        if w_l == nil{return false}

        // Add an tradcution-less word.
        let word_class : Translated_Word = Translated_Word(w, nil)
        // By the magic of classes and pointer, this will edit the original Words_Letter instance :D
        w_l!.words.append(word_class)

        return true
    }
    
    // Create a link between 2 Translated_Word
    func set_translation(_ w : String, _ translation : Translated_Word) -> Bool{
        var word_translated : Translated_Word? = self.get_Translated_Word(w)

        if word_translated == nil {return false}

        word_translated!.translation = translation
        return true
    }

    // UTILITY
    // Return true if the word is correct, false otherwise
    func is_word_correct(_ w : String) -> Bool{
        let l : Character? = w.first
        if l == nil{return false}
        return true
    }

    // Get the uppercased version of a character
    func char_to_maj(_ char : Character) -> Character{
        return char.uppercased().first!
    }

    // Get the Words_letter of a dictionnary, if it doesn't exit, return nil
    func get_letter_group(_ char : Character) -> Words_Letter?{
        for l in self.Letters{
            if l.LETTER == char{return l}
        }

        return nil
    }

    // Get the Translated_Word instance of a word.
    func get_Translated_Word(_ w : String) -> Translated_Word?{
        if !is_word_correct(w){return nil}
        if !self.is_in_dictionnary(w){return nil}

        let char : Character = w.first!
        // We knows there's a letter containing the word because is_in_dictionnary check passed.
        var w_l : Words_Letter = self.get_letter_group(char)!

        for word in w_l.words{

            if word.word == w{
                return word
            }
        }
        print("Did not found the word '\(w)'")
        return nil
    }

    // Show  all words beggining with a specified letter with their translation
    func show_dictionnary(_ specified_letter : Character) -> Void{
        let l : Words_Letter? = self.get_letter_group(specified_letter)
        if l == nil{print("[WARNING] Selected letter isn't in the dictionnary.")}
        else{
            var words_counter : Int = 0

            print("===WORDS BEGGINING WITH '\(specified_letter)'===")
            for word in l!.words{
                words_counter += 1
                print("\(words_counter) - \(word.word) (\(self.get_translation(word.word)))")
            }
            print("========================")
        }
    }

    // Show every words beggining with every letters with their translation
    func show_dictionnary() -> Void{
        for l in self.Letters{
            var words_counter : Int = 0

            print("===WORDS BEGGINING WITH '\(l.LETTER)'===")
            for word in l.words{
                words_counter += 1
                print("\(words_counter) - \(word.word) (\(self.get_translation(word.word)))")
            }
        }
        print("==============================")
    }
}

func create_translation(_ dict1 : Dictionnary, _ word1: String, _ dict2 : Dictionnary, _ word2 : String) -> Void{
    dict1.add_word(word1)
    dict2.add_word(word2)

    dict1.set_translation(word1,dict2.get_Translated_Word(word2)!)
    dict2.set_translation(word2,dict1.get_Translated_Word(word1)!)
}

// all of the french words
var FRENCH_DICT : Dictionnary = Dictionnary("French")
// all of the english words
var ENGLISH_DICT : Dictionnary = Dictionnary("English")

// Set de test
create_translation(FRENCH_DICT, "Manger", ENGLISH_DICT, "Eat")
create_translation(FRENCH_DICT, "Boire", ENGLISH_DICT, "Drink")
create_translation(FRENCH_DICT, "Table", ENGLISH_DICT, "Table")
create_translation(FRENCH_DICT, "Pomme", ENGLISH_DICT, "Apple")
create_translation(FRENCH_DICT, "Ordinateur", ENGLISH_DICT, "Computer")
create_translation(FRENCH_DICT, "Masque", ENGLISH_DICT, "Mask")
create_translation(FRENCH_DICT, "Objet", ENGLISH_DICT, "Object")
create_translation(FRENCH_DICT, "Orientée", ENGLISH_DICT, "Oriented")
create_translation(FRENCH_DICT, "Programme", ENGLISH_DICT, "Program")
create_translation(FRENCH_DICT, "Savoir", ENGLISH_DICT, "Know")
create_translation(FRENCH_DICT, "Atome", ENGLISH_DICT, "Atom")
create_translation(FRENCH_DICT, "Dormir", ENGLISH_DICT, "Sleep")
create_translation(FRENCH_DICT, "Jouer", ENGLISH_DICT, "Play")
create_translation(FRENCH_DICT, "Faire", ENGLISH_DICT, "Do")
create_translation(FRENCH_DICT, "Tête", ENGLISH_DICT, "Head")
create_translation(FRENCH_DICT, "Corps", ENGLISH_DICT, "Body")
create_translation(FRENCH_DICT, "Fusil", ENGLISH_DICT, "Rifle")
create_translation(FRENCH_DICT, "Oui", ENGLISH_DICT, "Yes")
create_translation(FRENCH_DICT, "Non", ENGLISH_DICT, "No")
create_translation(FRENCH_DICT, "Peut-être", ENGLISH_DICT, "Maybe")

print("FRENCH DICT : ")
FRENCH_DICT.show_dictionnary()
print("ENGLSIH DICT : ")
ENGLISH_DICT.show_dictionnary()

print("Translation of 'Tête' in English : \(FRENCH_DICT.get_translation("Tête"))")
print("Translation of 'Computer' in French : \(ENGLISH_DICT.get_translation("Computer"))")