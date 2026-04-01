package com.HaberesMonolitico.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.HaberesMonolitico.DTO.DepartamentoDTO;
import com.HaberesMonolitico.entities.Departamento;
import com.HaberesMonolitico.services.DepartamentoService;
import java.util.List;

@RestController
@RequestMapping("/departamentos")
public class DepartamentoController {

    private final DepartamentoService departamentoService;

    public DepartamentoController(DepartamentoService departamentoService) {
        this.departamentoService = departamentoService;
    }

    @GetMapping("/getAll")
    public List<Departamento> listarDepartamentos() {
        return departamentoService.listarDepartamentos();
    }
    
    @GetMapping("/testDepartamentos")
    public List<Departamento> testDepartamentos() {
        return departamentoService.listarDepartamentos();
    }
    
    @PostMapping
    public Departamento crearDepartamento(@RequestBody Departamento departamento) {
        return departamentoService.guardarDepartamento(departamento);
    }
    
    @PutMapping("/{id}")
    public Departamento actualizarDepartamento(@PathVariable("id") Long id, @RequestBody DepartamentoDTO dto) {
        return departamentoService.actualizarDepartamentoDesdeDTO(id, dto);
    }
}

