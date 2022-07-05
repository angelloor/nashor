import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { AttachedService } from '../attached.service';
import { Attached } from '../attached.types';
import { ModalSelectAttachedService } from './modal-select-attached.service';

@Component({
  selector: 'app-modal-select-attached',
  templateUrl: './modal-select-attached.component.html',
})
export class ModalSelectAttachedComponent implements OnInit {
  id_attached: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listAttached: Attached[] = [];
  selectAttachedForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _attachedService: AttachedService,
    private _modalSelectAttachedService: ModalSelectAttachedService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of attached
     */
    this._attachedService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_attacheds: Attached[]) => {
        this.listAttached = _attacheds;
      });
    /**
     * form
     */
    this.selectAttachedForm = this._formBuilder.group({
      id_attached: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectAttachedForm.patchValue({
      id_attached: this.selectAttachedForm.getRawValue().id_attached,
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
    this.id_attached = this.selectAttachedForm.getRawValue().id_attached;
    this.patchForm();
  }
  /**
   * closeModalSelectAttached
   */
  closeModalSelectAttached(): void {
    this._modalSelectAttachedService.closeModalSelectAttached();
  }
}
