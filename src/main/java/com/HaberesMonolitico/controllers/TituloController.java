package com.HaberesMonolitico.controllers;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.HaberesMonolitico.entities.Titulo;
import com.HaberesMonolitico.services.TituloService;

@RestController
@RequestMapping("/titulos")
public class TituloController {
	@Autowired
	TituloService tituloService;
	
	@GetMapping("/getAll")
	public List<Titulo> obtenerTodos(){
		return tituloService.listarTitulos();
	}
	
	@GetMapping("/{id}")
	public Optional<Titulo> obtenerPorId(Long id){
		return tituloService.obtenerTituloPorId(id);
	}
	
    @PostMapping
    public Titulo crearJerarquia(@RequestBody Titulo titulo) {
        return tituloService.guardarJerarquia(titulo);
    }
}
