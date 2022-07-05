import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ControlService } from '../control.service';
import { Control } from '../control.types';
import { ModalSelectControlService } from './modal-select-control.service';

@Component({
  selector: 'app-modal-select-control',
  templateUrl: './modal-select-control.component.html',
})
export class ModalSelectControlComponent implements OnInit {
  id_control: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listControl: Control[] = [];
  selectControlForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _controlService: ControlService,
    private _modalSelectControlService: ModalSelectControlService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of control
     */
    this._controlService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_controls: Control[]) => {
        this.listControl = _controls;
      });
    /**
     * form
     */
    this.selectControlForm = this._formBuilder.group({
      id_control: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectControlForm.patchValue({
      id_control: this.selectControlForm.getRawValue().id_control,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_control = this.selectControlForm.getRawValue().id_control;
    this.patchForm();
  }
  /**
   * closeModalSelectControl
   */
  closeModalSelectControl(): void {
    this._modalSelectControlService.closeModalSelectControl();
  }
}
