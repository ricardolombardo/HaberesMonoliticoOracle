package com.HaberesMonolitico.services;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.HaberesMonolitico.DTO.PersonaDTO;
import com.HaberesMonolitico.entities.Jerarquia;
import com.HaberesMonolitico.entities.Persona;
import com.HaberesMonolitico.entities.Titulo;
import com.HaberesMonolitico.repositories.PersonaRepository;

@Service
public class PersonaService {

	@Autowired
    private PersonaRepository personaRepository;
	
	@Autowired
	private DepartamentoService departamentoService;
	
	@Autowired
	private JerarquiaService jerarquiaService;
	
	@Autowired
	private TituloService tituloService;
	
	public List<Persona> listarPersonas() {
        return personaRepository.findAll();
    }

    public Optional<Persona> obtenerPersonaPorId(Long id) {
        return personaRepository.findById(id);
    }
    
    public Optional<Persona> obtenerPersonaPorNou(int numeroNou) {
    	return personaRepository.findByNou(numeroNou).map(nou -> nou.getPersona());
    }

    public Persona guardarPersona(Persona persona) {
        return personaRepository.save(persona);
    }
    
    public Persona guardarPersonaConDTO(PersonaDTO dto) {
    	
        Persona persona = new Persona();
        persona.setNombre(dto.getNombre());
        persona.setApellidoPaterno(dto.getApellidoPaterno());
        persona.setApellidoMaterno(dto.getApellidoMaterno());
        persona.setAntiguedad(dto.getAntiguedad());
        persona.setActivo(dto.getActivo());
        persona.setDepartamento(departamentoService.obtenerPorId(dto.getDepartamentoId()));
        
        Optional<Jerarquia> jerarquia=jerarquiaService.obtenerJerarquiaPorId(dto.getJerarquiaId());
        persona.setJerarquia(jerarquia.get());
        
        Optional<Titulo> titulo=tituloService.obtenerTituloPorId(dto.getTituloId());
        persona.setTitulo(titulo.get());
    	
        return personaRepository.save(persona);
    }

    public void eliminarPersona(Long id) {
    	personaRepository.deleteById(id);
    }

    public Persona actualizarPersonaDesdeDTO(Long id, PersonaDTO dto) {
        Optional<Persona> personaOpt = personaRepository.findById(id);
        if (personaOpt.isPresent()) {
            Persona persona = personaOpt.get();
            persona.setNombre(dto.getNombre());
            persona.setApellidoPaterno(dto.getApellidoPaterno());
            persona.setApellidoMaterno(dto.getApellidoMaterno());
            persona.setDepartamento(departamentoService.obtenerPorId(dto.getDepartamentoId()));
            
            Optional<Jerarquia> jerarquia=jerarquiaService.obtenerJerarquiaPorId(dto.getJerarquiaId());
            persona.setJerarquia(jerarquia.get());
            
            Optional<Titulo> titulo=tituloService.obtenerTituloPorId(dto.getTituloId());
            persona.setTitulo(titulo.get());
            
            return personaRepository.save(persona);
        } else {
            throw new RuntimeException("Persona no encontrada con ID: " + id);
        }
    }
	
}
